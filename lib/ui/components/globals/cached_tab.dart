import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/app/utils/cached_helper.dart';
import 'package:semesta/core/mixins/pager_mixin.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/ui/components/globals/items_builder.dart';

typedef LoadFn<T> = Future<List<T>> Function();
typedef ItemBuilder<T> = Widget Function(T item);

class CachedTab<T extends HasAttributes> extends StatefulWidget {
  final PagerMixin<T> controller;
  final CachedState<T> cache;
  final bool isGrid, autoLoad;

  final LoadFn<T> onInitial;
  final LoadFn<T> onMore;
  final LoadFn<T> onRefresh;

  final ScrollController? scroller;

  final ItemBuilder<T> itemBuilder;
  final String emptyMessage;

  const CachedTab({
    super.key,
    required this.controller,
    required this.cache,
    required this.itemBuilder,
    this.emptyMessage = 'No data available',
    this.scroller,
    this.isGrid = false,
    required this.onInitial,
    required this.onMore,
    required this.onRefresh,
    this.autoLoad = true,
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
        isLoading: ctrl.anyLoading,
        isLoadingNext: ctrl.loadingMore.value,

        // Data
        counter: items.length,
        isEmpty: items.isEmpty,
        builder: (ctx, idx) => widget.itemBuilder(items[idx]),

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
