import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/user_repository.dart';
import 'package:semesta/public/utils/type_def.dart';

class AuthRepository extends UserRepository {
  // ---------- SIGN UP ----------
  Wait<User?> signUp(Author model, String password, [File? file]) async {
    final response = await auth.createUserWithEmailAndPassword(
      email: model.email,
      password: password,
    );

    final author = response.user;
    if (author == null) return null;

    final id = author.uid;
    final media = await pushFile(id, file, StoredIn.avatar);
    final data = model.copyWith(
      id: id,
      media: media,
      verified: author.emailVerified,
    );
    await createUser(data);

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
    final id = author.uid;
    final name = author.displayName;
    final data = Author(
      id: id,
      email: email,
      name: name ?? '',
      verified: author.emailVerified,
      media: Media(url: author.photoURL ?? ''),
      uname: name?.toUsername ?? fakeName.toUsername,
    );

    if (!await exists(id)) await createUser(data);

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
      final id = author.uid;
      final name = author.displayName;
      final data = Author(
        id: id,
        name: name ?? '',
        email: author.email ?? '',
        verified: author.emailVerified,
        media: Media(url: author.photoURL ?? ''),
        uname: name?.toUsername ?? fakeName.toUsername,
      );

      if (!await exists(id)) await createUser(data);

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

  Wait<bool> exists(String doc) => existing(users, doc);

  // ---------- SIGN OUT ----------
  AsWait signOut() async {
    await auth.signOut();
    // await google.signOut();
    // await facebook.logOut();
  }
}
