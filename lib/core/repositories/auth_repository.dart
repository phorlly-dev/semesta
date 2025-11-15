import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/user_repository.dart';
import 'package:semesta/core/services/firebase_service.dart';

class AuthRepository extends FirebaseService {
  final _repo = UserRepository();

  // ---------- SIGN UP ----------
  Future<User?> signUp(
    String email,
    String password,
    File file,
    UserModel model,
  ) async {
    final response = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = response.user;
    if (firebaseUser == null) return null;

    final avatarUrl = await _repo.uploadProfile(firebaseUser.uid, file);
    await _repo.createUser(firebaseUser.uid, model.copyWith(avatar: avatarUrl));

    return firebaseUser;
  }

  // ---------- SIGN IN ----------
  Future<User?> signIn(String email, String password) async {
    final response = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = response.user;
    if (firebaseUser == null) return null;

    // Ensure Firestore user exists (e.g., for old accounts)
    final notExist = await _repo.isNotExist(firebaseUser.uid);
    if (notExist) {
      await _repo.createUser(
        firebaseUser.uid,
        UserModel(
          email: email,
          name: firebaseUser.displayName ?? '',
          avatar: firebaseUser.photoURL ?? '',
          token: firebaseUser.refreshToken ?? '',
        ),
      );
    }

    return firebaseUser;
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await google.authenticate();

      // Obtain the auth details from the request
      final googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final response = await auth.signInWithCredential(credential);
      final firebaseUser = response.user;
      if (firebaseUser == null) return null;

      // Ensure Firestore user exists (e.g., for old accounts)
      final notExist = await _repo.isNotExist(firebaseUser.uid);
      if (notExist) {
        await _repo.createUser(
          firebaseUser.uid,
          UserModel(
            email: firebaseUser.email,
            name: firebaseUser.displayName ?? '',
            avatar: firebaseUser.photoURL ?? '',
            token: firebaseUser.refreshToken ?? '',
          ),
        );
      }

      return firebaseUser;
      // proceed
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('User canceled sign in.');
      } else {
        print('Sign in failed: $e');
      }
    }

    return null;
  }

  Future<User?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final result = await facebook.login();

    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken!;
      final credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      final response = await auth.signInWithCredential(credential);
      final firebaseUser = response.user;
      if (firebaseUser == null) return null;

      // Ensure Firestore user exists (e.g., for old accounts)
      final notExist = await _repo.isNotExist(firebaseUser.uid);
      if (notExist) {
        await _repo.createUser(
          firebaseUser.uid,
          UserModel(
            email: firebaseUser.email,
            name: firebaseUser.displayName ?? '',
            avatar: firebaseUser.photoURL ?? '',
            token: firebaseUser.refreshToken ?? '',
          ),
        );
      }

      return firebaseUser;
    } else {
      print('Facebook login failed: ${result.status}');
      return null;
    }
  }

  // ---------- SIGN OUT ----------
  Future<void> signOut() async {
    await auth.signOut();
    // await google.signOut();
    // await facebook.logOut();
  }
}
