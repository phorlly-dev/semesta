import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semesta/public/utils/type_def.dart';

class RouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _authSub;
  late final VoidCallback _readyListener;
  final ValueNotifier<bool> _ready;

  RouterRefreshStream(Stream<User?> authStream, ValueNotifier<bool> ready)
    : _ready = ready {
    _authSub = authStream.asBroadcastStream().listen((_) => notifyListeners());
    _readyListener = () => notifyListeners();
    _ready.addListener(_readyListener);
  }

  @override
  void dispose() {
    _authSub.cancel();
    _ready.removeListener(_readyListener);
    super.dispose();
  }
}

Sync<T> debounceStream<T>(Sync<T> source, Duration delay) {
  Timer? timer;
  StreamController<T>? controller;

  controller = StreamController<T>(
    onListen: () => source.listen(
      (event) {
        timer?.cancel();
        timer = Timer(delay, () => controller!.add(event));
      },
      onError: controller!.addError,
      onDone: controller.close,
    ),
  );

  return controller.stream;
}
