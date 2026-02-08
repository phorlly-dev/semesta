import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class DirectionController extends GetxController {
  final visible = true.obs;
  final index = 0.obs;
  final controllers = List.generate(3, (_) => ScrollController());

  void jump() => controllers[index.value].animateTo(
    0,
    duration: Durations.extralong4,
    curve: Curves.easeOut,
  );

  @override
  void onInit() {
    ever(index, (index) => _attachListener(index));
    _attachListener(0); // default

    super.onInit();
  }

  void _attachListener(int index) {
    for (final ctrl in controllers) {
      ctrl.removeListener(_listener);
    }
    controllers[index].addListener(_listener);
    update();
  }

  void _listener() {
    final ctrl = controllers[index.value];
    if (!ctrl.hasClients) return;

    final direction = ctrl.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      visible.value = false;
    } else if (direction == ScrollDirection.forward) {
      visible.value = true;
    }
  }

  @override
  void onClose() {
    for (final ctrl in controllers) {
      ctrl.dispose();
    }
    super.onClose();
  }
}
