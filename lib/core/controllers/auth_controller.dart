import 'package:firebase_auth/firebase_auth.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/repositories/auth_repository.dart';

class AuthController extends IController<User> {
  final _authRepo = AuthRepository();

  @override
  void onInit() {
    item.bindStream(_authRepo.auth.authStateChanges());
    super.onInit();
  }

  bool get isLoggedIn => item.value != null;

  void login(String email, String password) {
    handleAsyncOperation(
      body: () async => await _authRepo.signIn(email, password),
      error: (err) => hasError.value = handleError(err),
    );
  }

  void register(String email, String password) {
    handleAsyncOperation(
      body: () async => await _authRepo.signUp(email, password),
      error: (err) => hasError.value = handleError(err),
    );
  }

  void loginWithGoogle() {
    handleAsyncOperation(body: () async => await _authRepo.signInWithGoogle());
  }

  void loginWithFacebook() {
    handleAsyncOperation(
      body: () async => await _authRepo.signInWithFacebook(),
    );
  }

  Future<void> logout() async {
    await _authRepo.signOut();
  }

  // ---------- ERROR HANDLER ----------
  String handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password too weak';
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Incorrect password';
      default:
        return e.message ?? 'Unexpected error';
    }
  }
}
