import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class DirectionController extends GetxController {
  final isVisible = true.obs;
  final currentIndex = 0.obs;
  final scrollControllers = List.generate(8, (_) => ScrollController());

  void get jump => scrollControllers[currentIndex.value].animateTo(
    0,
    duration: Durations.extralong4,
    curve: Curves.easeOut,
  );

  @override
  void onInit() {
    ever(currentIndex, (index) {
      _attachListener(index);
    });
    _attachListener(0); // default

    super.onInit();
  }

  void _attachListener(int index) {
    for (final ctrl in scrollControllers) {
      ctrl.removeListener(_listener);
    }
    scrollControllers[index].addListener(_listener);
    update();
  }

  void _listener() {
    final controller = scrollControllers[currentIndex.value];
    if (!controller.hasClients) return;

    final direction = controller.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      isVisible.value = false;
    } else if (direction == ScrollDirection.forward) {
      isVisible.value = true;
    }
  }

  @override
  void onClose() {
    for (final ctrl in scrollControllers) {
      ctrl.dispose();
    }
    super.onClose();
  }
}
