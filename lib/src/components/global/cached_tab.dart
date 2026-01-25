import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/public/mixins/pager_mixin.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/src/components/global/items_builder.dart';

typedef LoadFn<T> = Future<List<T>> Function();
typedef ItemBuilder<T> = Widget Function(T item);

class CachedTab<T extends HasAttributes> extends StatefulWidget {
  final PagerMixin<T> controller;
  final CachedState<T> cache;
  final bool isGrid, autoLoad, isBreak;

  final LoadFn<T> onInitial;
  final LoadFn<T> onMore;
  final LoadFn<T> onRefresh;

  final ScrollController? scroller;

  final ItemBuilder<T> builder;
  final String emptyMessage;

  const CachedTab({
    super.key,
    this.scroller,
    required this.cache,
    required this.onMore,
    required this.onInitial,
    required this.onRefresh,
    required this.controller,
    required this.builder,
    this.isGrid = false,
    this.autoLoad = true,
    this.isBreak = false,
    this.emptyMessage = 'No data available',
  });

  @override
  State<CachedTab<T>> createState() => _CachedTabState<T>();
}

class _CachedTabState<T extends HasAttributes> extends State<CachedTab<T>> {
  @override
  void initState() {
    if (widget.autoLoad) _loadInit();
    super.initState();
  }

  Future<void> _loadInit() async {
    // Use addPostFrameCallback instead of microtask for better timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.controller.loadStart(
        fetch: widget.onInitial,
        apply: (items) => widget.cache.set(items),
        onError: () => _showError('Failed to load data'),
      );
    });
  }

  Future<void> _handleMore() async {
    await widget.controller.loadMore(
      fetch: widget.onMore,
      apply: (items) => widget.cache.append(items),
      onError: () => _showError('Failed to load more'),
    );
  }

  Future<void> _handleRefresh() async {
    await widget.controller.loadLatest(
      fetch: widget.onRefresh,
      apply: (items) => widget.cache
        ..clear()
        ..set(items),
      onError: () => _showError('Failed to refresh'),
    );
  }

  Future<void> _handleRetry() async {
    await widget.controller.retry(
      fetch: widget.onInitial,
      apply: (items) => widget.cache.set(items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = widget.controller;
      final items = widget.cache;

      return ItemsBuilder(
        // Scroll
        scroller: widget.scroller,

        // State
        isGrid: widget.isGrid,
        isBreak: widget.isBreak,
        isLoading: ctrl.anyLoading,
        isLoadingNext: ctrl.loadingMore.value,

        // Data
        counter: items.length,
        isEmpty: items.isEmpty,
        builder: (ctx, idx) => widget.builder(items[idx]),

        // Empty and error state
        hasError: ctrl.error.value,
        message: widget.emptyMessage,

        // Callbacks
        onMore: _handleMore,
        onRefresh: _handleRefresh,
        onRetry: _handleRetry,
      );
    });
  }

  void _showError(String title) {
    if (!mounted) return;

    final errorMessage = widget.controller.error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
