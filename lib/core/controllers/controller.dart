import 'dart:math';

import 'package:get/get.dart';
import 'package:semesta/app/utils/logger.dart';
import 'package:semesta/app/utils/type_def.dart';

abstract class IController<T> extends GetxController {
  final RxString hasError = ''.obs;
  final RxString infoMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<T> elements = <T>[].obs;
  final dataMapping = <String, T>{}.obs;

  /// A reusable async handler for try/catch/finally logic.
  Future<void> handleAsync({
    required FutureCallback<void> callback,
    ErrorCallback<void>? onError,
    PropsCallback<bool, void>? onFinal,
  }) async {
    // 1. Set loading state to true *before* the operation starts.
    isLoading.value = true;
    try {
      // 2. Clear any previous error.
      hasError.value = ''; // Or an empty string, depending on your type

      // 3. Execute the function with () and await its completion.
      await callback();

      // 4. Consolidate error handling to catch all errors and exceptions.
    } catch (e, stack) {
      if (onError != null) onError(e);
      hasError.value = e.toString();
      HandleLogger.error('Operation Failed on $T', message: e, stack: stack);
    } finally {
      // 5. This now correctly runs *after* the async operation is done.
      isLoading.value = false;
      onFinal?.call(false);
    }
  }

  Future<void> tryCatch({
    required FutureCallback<void> callback,
    ErrorCallback<void>? onError,
    PropsCallback<bool, void>? onFinal,
  }) async {
    try {
      await callback();
    } catch (e, stack) {
      onError?.call(e);
      HandleLogger.error('Operation Failed on $T', message: e, stack: stack);
    } finally {
      onFinal?.call(false);
    }
  }

  final rand = Random();
  String getRandomId(List<String> ids) {
    if (ids.isEmpty) return 'unknown';

    return ids[rand.nextInt(ids.length)];
  }
}
