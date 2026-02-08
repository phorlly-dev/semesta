import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/auth_repository.dart';
import 'package:semesta/public/utils/type_def.dart';

class AuthController extends GetxController {
  final _repo = AuthRepository();
  final currentUser = Rxn<User>(null);
  final loading = false.obs;

  @override
  void onInit() {
    _bindAuthStream();
    super.onInit();
  }

  bool get loggedIn => currentUser.value != null;

  AsWait login(String email, String password) => _exhandler(() async {
    currentUser.value = await _repo.signIn(email, password);
  });

  AsWait register(Author model, String password, [File? file]) => _exhandler(
    () async {
      currentUser.value = await _repo.signUp(model, password, file);
    },
    type: ToastType.info,
    message: 'Account Created',
  );

  AsWait loginWithGoogle() async => await _repo.signInWithGoogle();

  // AsWait loginWithFacebook() async => await _repo.signInWithFacebook();

  AsWait logout() => _exhandler(
    () async {
      await _repo.signOut();
      currentUser.value = null;
    },
    type: ToastType.warning,
    message: 'Signed out',
  );

  AsWait _exhandler(
    AsDef callback, {
    String message = 'Verify Successful',
    ToastType type = ToastType.success,
  }) async {
    loading.value = true;
    try {
      await callback();
      await Wait.delayed(Durations.medium2, () => _bindAuthStream());
      CustomToast.render(message, type: type);
    } on FirebaseAuthException catch (err) {
      CustomToast.error(_handleError(err));
      HandleLogger.track('Firebase auth exception', error: err);
    } catch (e, s) {
      HandleLogger.error('Something when wrong', error: e, stack: s);
    } finally {
      loading.value = false;
    }
  }

  StreamSubscription? _authSub;
  void _bindAuthStream() {
    _authSub = _repo.auth.authStateChanges().listen((user) {
      currentUser.value = user;
      HandleLogger.info('🔥 Auth state updated: $user');
    });
  }

  // ---------- ERROR HANDLER ----------
  String _handleError(FirebaseAuthException e) {
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
