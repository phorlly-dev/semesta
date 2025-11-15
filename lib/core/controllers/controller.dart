import 'dart:math';

import 'package:get/get.dart';
import 'package:semesta/app/utils/logger.dart';

abstract class IController<T> extends GetxController {
  var hasError = ''.obs;
  var infoMessage = ''.obs;
  var isLoading = false.obs;
  var items = <T>[].obs;
  var item = Rxn<T>(null);

  /// A reusable async handler for try/catch/finally logic.
  Future<void> handleAsyncOperation({
    required Future<void> Function() callback,
    void Function(Object? err)? onError,
  }) async {
    try {
      // 1. Set loading state to true *before* the operation starts.
      isLoading.value = true;

      // 2. Clear any previous error.
      hasError.value = ''; // Or an empty string, depending on your type

      // 3. Execute the function with () and await its completion.
      await callback();

      // 4. Consolidate error handling to catch all errors and exceptions.
    } catch (e, stack) {
      if (onError != null) onError(e);
      hasError.value = e.toString();
      HandleLogger.err('Operation Failed', error: e, stack: stack);
    } finally {
      // 5. This now correctly runs *after* the async operation is done.
      isLoading.value = false;
    }
  }

  final _rand = Random();
  String getRandomId(List<String> ids) {
    if (ids.isEmpty) return 'unknown';
    return ids[_rand.nextInt(ids.length)];
  }
}
