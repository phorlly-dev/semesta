import 'package:firebase_auth/firebase_auth.dart';
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
    required Future<void> Function() body,
    void Function(FirebaseAuthException err)? error,
  }) async {
    try {
      // 1. Set loading state to true *before* the operation starts.
      isLoading.value = true;

      // 2. Clear any previous error.
      hasError.value = ''; // Or an empty string, depending on your type

      // 3. Execute the function with () and await its completion.
      await body();

      // 4. Consolidate error handling to catch all errors and exceptions.
    } on FirebaseAuthException catch (err) {
      HandleLogger('Firebase Auth Exception', error: err, type: LogType.track);
      if (error != null) error(err);
    } catch (e, stack) {
      HandleLogger('Operation Failed', error: e, stack: stack);
      hasError.value = e.toString();
    } finally {
      // 5. This now correctly runs *after* the async operation is done.
      isLoading.value = false;
    }
  }
}
