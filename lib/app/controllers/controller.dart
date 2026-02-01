import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/mixins/pager_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';

abstract class IController<T> extends GetxController with PagerMixin<T> {
  final isLoading = false.obs;
  final RxString hasError = ''.obs;
  final RxString message = ''.obs;

  /// A reusable async handler for try/catch/finally logic.
  AsWait handleAsync({
    AsError? onError,
    required AsDef callback,
    ValueChanged<bool>? onFinal,
  }) async {
    // 1. Set loading state to true *before* the operation starts.
    isLoading.value = true;
    try {
      // 2. Clear any previous error.
      hasError.value = ''; // Or an empty string, depending on your type
      message.value = '';

      // 3. Execute the function with () and await its completion.
      await callback();

      // 4. Consolidate error handling to catch all errors and exceptions.
    } catch (e, s) {
      if (onError != null) onError(e, s);
      hasError.value = e.toString();
      HandleLogger.error('Operation Failed on $T', message: e, stack: s);
    } finally {
      // 5. This now correctly runs *after* the async operation is done.
      isLoading.value = false;
      onFinal?.call(false);
    }
  }

  AsWait tryCatch({
    AsError? onError,
    required AsDef callback,
    ValueChanged<bool>? onFinal,
  }) async {
    try {
      await callback();
    } catch (e, s) {
      onError?.call(e, s);
      HandleLogger.error('Operation Failed on $T', message: e, stack: s);
    } finally {
      onFinal?.call(false);
    }
  }

  final rand = Random();
  int get sessionSeed => rand.nextInt(1 << 31);
  int get refreshSeed => sessionSeed + rand.nextInt(1000);
  String getRandomId(List<String> ids) {
    if (ids.isEmpty) return 'unknown';

    return ids[rand.nextInt(ids.length)];
  }
}
