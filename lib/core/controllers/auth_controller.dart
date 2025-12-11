import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:semesta/app/utils/custom_toast.dart';
import 'package:semesta/app/utils/logger.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final _authRepo = AuthRepository();
  final currentUser = Rxn<User>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    _bindAuthStream();
    super.onInit();
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authRepo.signIn(email, password);

      // Force currentUser refresh
      currentUser.value = user;
      CustomToast.success('Verify Successful');
      await Future.delayed(const Duration(milliseconds: 300));
      _bindAuthStream(); // ensure stream reconnected
    } on FirebaseAuthException catch (err) {
      CustomToast.error(handleError(err));
      HandleLogger.track('Firebase Auth Exception', message: err);
    } catch (e, s) {
      HandleLogger.error('Someyhing Wrong', message: e, stack: s);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    File file,
    UserModel model,
  ) async {
    isLoading.value = true;
    try {
      final user = await _authRepo.signUp(email, password, file, model);

      // Force currentUser refresh
      currentUser.value = user;
      CustomToast.info('Account Created');
      await Future.delayed(const Duration(milliseconds: 300));
      _bindAuthStream(); // ensure stream reconnected
    } on FirebaseAuthException catch (err) {
      CustomToast.error(handleError(err));
      HandleLogger.track('Firebase Auth Exception', message: err);
    } catch (e, s) {
      HandleLogger.error('Someyhing Wrong', message: e, stack: s);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async => await _authRepo.signInWithGoogle();

  Future<void> loginWithFacebook() async =>
      await _authRepo.signInWithFacebook();

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepo.signOut();
      currentUser.value = null;
      CustomToast.warning('You have been signed out');
      await Future.delayed(const Duration(milliseconds: 300));
      _bindAuthStream();
    } on FirebaseAuthException catch (err) {
      HandleLogger.track('Firebase Auth Exception', message: err);
    } catch (e, s) {
      HandleLogger.error('Someyhing Wrong', message: e, stack: s);
    } finally {
      isLoading.value = false;
    }
  }

  StreamSubscription? _authSub;
  void _bindAuthStream() {
    _authSub = _authRepo.auth.authStateChanges().listen((user) {
      currentUser.value = user;
      HandleLogger.info('🔥 Auth state updated: $user');
    });
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

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }
}
