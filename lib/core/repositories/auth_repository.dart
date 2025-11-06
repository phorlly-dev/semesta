import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:semesta/core/repositories/repository.dart';

class AuthRepository extends IRepository {
  // ---------- SIGN UP ----------
  Future<User?> signUp(String email, String password) async {
    final response = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return response.user;
  }

  // ---------- SIGN IN ----------
  Future<User?> signIn(String email, String password) async {
    final response = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return response.user;
  }

  Future<User?> signInWithGoogle() async {
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

    return response.user;
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

      return response.user;
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
