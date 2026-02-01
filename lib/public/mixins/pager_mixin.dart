import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

typedef Fetch<T> = Def<List<T>>;
typedef Apply<T> = ValueChanged<List<T>>;

mixin PagerMixin<T> on GetxController {
  final loading = false.obs;
  final loadingMore = false.obs;
  final refreshing = false.obs;
  final hasMore = true.obs;
  final error = Rxn<String>();

  /// Initial load or refresh from start
  AsWait loadStart({
    required Fetch<T> fetch,
    required Apply<T> apply,
    int pageSize = 20,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (loading.value) return;

    loading.value = true;
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
      loading.value = false;
    }
  }

  /// Load next page
  AsWait loadMore({
    required Fetch<T> fetch,
    required Apply<T> apply,
    int pageSize = 20,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (loadingMore.value || !hasMore.value || loading.value) return;

    loadingMore.value = true;
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
        await Wait.delayed(Duration(milliseconds: 300 - elapsed));
      }

      apply(items);
      hasMore.value = items.length >= pageSize;
      onSuccess?.call();
    } catch (e, stack) {
      error.value = e.toString();
      HandleLogger.error('Failed to load more $T', message: e, stack: stack);
      onError?.call();
    } finally {
      loadingMore.value = false;
    }
  }

  /// Pull-to-refresh: load latest items
  AsWait loadLatest({
    required Fetch<T> fetch,
    required Apply<T> apply,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (refreshing.value) return;

    refreshing.value = true;
    error.value = null;
    try {
      final start = now;
      final items = await fetch();

      final elapsed = now.difference(start);
      if (elapsed < const Duration(milliseconds: 400)) {
        await Wait.delayed(const Duration(milliseconds: 400) - elapsed);
      }

      apply(items);
      onSuccess?.call();
    } catch (e, stack) {
      error.value = e.toString();
      HandleLogger.error('Failed to refresh $T', message: e, stack: stack);
      onError?.call();
    } finally {
      refreshing.value = false;
    }
  }

  /// Retry after error
  AsWait retry({
    required Fetch<T> fetch,
    required Apply<T> apply,
    int pageSize = 20,
  }) async {
    resetPagination();
    await loadStart(fetch: fetch, apply: apply, pageSize: pageSize);
  }

  /// Reset pagination state
  void resetPagination() {
    loading.value = false;
    loadingMore.value = false;
    refreshing.value = false;
    hasMore.value = true;
    error.value = null;
  }

  bool get anyLoading => loading.value || refreshing.value;
}
