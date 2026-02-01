import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/user_repository.dart';
import 'package:semesta/public/utils/type_def.dart';

class AuthRepository extends UserRepository {
  // ---------- SIGN UP ----------
  Wait<User?> signUp(
    String email,
    String password,
    File file,
    Author model,
  ) async {
    final response = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final author = response.user;
    if (author == null) return null;

    final avatarUrl = await uploadProfile(author.uid, file);
    await createUser(
      model.copy(avatar: avatarUrl?.display, id: author.uid),
      avatarUrl?.path,
    );

    return author;
  }

  // ---------- SIGN IN ----------
  Wait<User?> signIn(String email, String password) async {
    final response = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final author = response.user;
    if (author == null) return null;

    // Ensure Firestore user exists (e.g., for old accounts)
    final exist = await exists(author.uid);
    if (!exist) {
      await createUser(
        Author(
          id: author.uid,
          uname: getUname(author.displayName ?? fakeName),
          email: email,
          name: author.displayName ?? '',
          avatar: author.photoURL ?? '',
        ),
      );
    }

    return author;
  }

  Wait<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await gg.authenticate();

      // Obtain the auth details from the request
      final googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final response = await auth.signInWithCredential(credential);
      final author = response.user;
      if (author == null) return null;

      // Ensure Firestore user exists (e.g., for old accounts)
      final exist = await exists(author.uid);
      if (!exist) {
        await createUser(
          Author(
            id: author.uid,
            uname: getUname(author.displayName ?? fakeName),
            email: author.email,
            name: author.displayName ?? '',
            avatar: author.photoURL ?? '',
          ),
        );
      }

      return author;
      // proceed
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        HandleLogger.error('User canceled sign in.');
      } else {
        HandleLogger.error('Sign in failed: $e');
      }
    }

    return null;
  }

  // Wait<User?> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final result = await fb.login();

  //   if (result.status == LoginStatus.success) {
  //     final accessToken = result.accessToken!;
  //     final credential = FacebookAuthProvider.credential(accessToken.token);

  //     final response = await auth.signInWithCredential(credential);
  //     final author = response.user;
  //     if (author == null) return null;

  //     // Ensure Firestore user exists (e.g., for old accounts)
  //     final exist = await exists(author.uid);
  //     if (!exist) {
  //       await createUser(
  //         Author(
  //           id: author.uid,
  //           username: generateUsername(author.displayName ?? fakeName),
  //           email: author.email,
  //           name: author.displayName ?? '',
  //           avatar: author.photoURL ?? '',
  //         ),
  //       );
  //     }

  //     return author;
  //   } else {
  //     HandleLogger.error('Facebook login failed: ${result.status}');
  //     return null;
  //   }
  // }

  Wait<bool> exists(String child) async => isExists(users, child);

  // ---------- SIGN OUT ----------
  AsWait signOut() async {
    await auth.signOut();
    // await google.signOut();
    // await facebook.logOut();
  }
}
