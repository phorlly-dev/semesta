import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/globals/items_builder.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class FeedForYouTab extends StatefulWidget {
  final ScrollController scroller;
  const FeedForYouTab({super.key, required this.scroller});

  @override
  State<FeedForYouTab> createState() => _FeedForYouTabState();
}

class _FeedForYouTabState extends State<FeedForYouTab> {
  final _ctrl = Get.find<PostController>();

  @override
  void initState() {
    _loadInit();
    super.initState();
  }

  Future<void> _loadInit([bool retred = false]) async {
    // Use addPostFrameCallback instead of microtask for better timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final session = _ctrl.sessionSeed;
      if (retred) {
        _ctrl.retry(
          fetch: _ctrl.loadMoreForYou,
          apply: (items) {
            final ranked = items.rankFeed(session);
            _ctrl.stateFor('home:all').set(ranked);
          },
        );
      } else {
        _ctrl.loadStart(
          fetch: _ctrl.loadMoreForYou,
          apply: (items) {
            final ranked = items.rankFeed(session);
            _ctrl.stateFor('home:all').set(ranked);
          },
          onError: () => _showError('Failed to load data'),
        );
      }
    });
  }

  Future<void> _loadMore() async {
    await _ctrl.loadMore(
      fetch: () => _ctrl.loadMoreForYou(QueryMode.next),
      apply: (items) {
        final ranked = items.rankFeed(_ctrl.sessionSeed);
        _ctrl.stateFor('home:all').append(ranked);
      },
      onError: () => _showError('Failed to load more'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final states = _ctrl.stateFor('home:all');
      return ItemsBuilder(
        scroller: widget.scroller,
        counter: states.length,
        isEmpty: states.isEmpty,
        isLoading: _ctrl.isAnyLoading,
        isLoadingNext: _ctrl.isLoadingMore.value,
        message: "There's no posts yet.",
        hasError: _ctrl.error.value,
        builder: (ctx, idx) => LiveFeed(feed: states[idx]),
        onMore: _loadMore,
        onRefresh: _ctrl.refreshPost,
        onRetry: () => _loadInit(true),
      );
    });
  }

  void _showError(String title) {
    if (!mounted) return;

    final errorMessage = _ctrl.error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
