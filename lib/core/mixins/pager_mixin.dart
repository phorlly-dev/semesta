import 'dart:ui';
import 'package:get/get.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/app/utils/type_def.dart';

typedef PageFetch<T> = FutureCallback<List<T>>;
typedef PageApply<T> = void Function(List<T> items);

mixin PagerMixin<T> on GetxController {
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final hasMore = true.obs;
  final error = Rxn<String>();

  /// Initial load or refresh from start
  Future<void> loadStart({
    required PageFetch<T> fetch,
    required PageApply<T> apply,
    int pageSize = 20,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = null;
    try {
      final items = await fetch();

      apply(items);
      hasMore.value = items.length >= pageSize;
      onSuccess?.call();
    } catch (e, stack) {
      error.value = e.toString();
      HandleLogger.error('Failed to load $T', message: e, stack: stack);
      onError?.call();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next page
  Future<void> loadMore({
    required PageFetch<T> fetch,
    required PageApply<T> apply,
    int pageSize = 20,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) return;

    isLoadingMore.value = true;
    error.value = null;
    try {
      final sw = Stopwatch()..start();
      final items = await fetch();
      if (items.isEmpty) {
        hasMore.value = false;
        return;
      }

      final elapsed = sw.elapsedMilliseconds;
      if (elapsed < 300) {
        await Future.delayed(Duration(milliseconds: 300 - elapsed));
      }

      apply(items);
      hasMore.value = items.length >= pageSize;
      onSuccess?.call();
    } catch (e, stack) {
      error.value = e.toString();
      HandleLogger.error('Failed to load more $T', message: e, stack: stack);
      onError?.call();
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Pull-to-refresh: load latest items
  Future<void> loadLatest({
    required PageFetch<T> fetch,
    required PageApply<T> apply,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    error.value = null;
    try {
      final start = now;
      final items = await fetch();

      final elapsed = now.difference(start);
      if (elapsed < const Duration(milliseconds: 400)) {
        await Future.delayed(const Duration(milliseconds: 400) - elapsed);
      }

      apply(items);
      onSuccess?.call();
    } catch (e, stack) {
      error.value = e.toString();
      HandleLogger.error('Failed to refresh $T', message: e, stack: stack);
      onError?.call();
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Retry after error
  Future<void> retry({
    required PageFetch<T> fetch,
    required PageApply<T> apply,
    int pageSize = 20,
  }) async {
    resetPagination();
    await loadStart(fetch: fetch, apply: apply, pageSize: pageSize);
  }

  /// Reset pagination state
  void resetPagination() {
    isLoading.value = false;
    isLoadingMore.value = false;
    isRefreshing.value = false;
    hasMore.value = true;
    error.value = null;
  }

  bool get isAnyLoading => isLoading.value || isRefreshing.value;
}
