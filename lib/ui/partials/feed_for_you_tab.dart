import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/items_builder.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class FeedForYouTab extends StatefulWidget {
  final ScrollController scroller;
  const FeedForYouTab({super.key, required this.scroller});

  @override
  State<FeedForYouTab> createState() => _FeedForYouTabState();
}

class _FeedForYouTabState extends State<FeedForYouTab> {
  final _key = getKey();

  @override
  void initState() {
    _loadInit();
    super.initState();
  }

  Future<void> _loadInit([bool retred = false]) async {
    // Use addPostFrameCallback instead of microtask for better timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      pctrl.freeOldPosts();
      final session = pctrl.sessionSeed;
      if (retred) {
        pctrl.retry(
          fetch: pctrl.loadMoreForYou,
          apply: (items) {
            final ranked = items.rankFeed(session);
            pctrl.stateFor(_key).set(ranked);
          },
        );
      } else {
        pctrl.loadStart(
          fetch: pctrl.loadMoreForYou,
          apply: (items) {
            final ranked = items.rankFeed(session);
            pctrl.stateFor(_key).set(ranked);
          },
          onError: () => _showError('Failed to load data'),
        );
      }
    });
  }

  Future<void> _loadMore() async {
    await pctrl.loadMore(
      fetch: () => pctrl.loadMoreForYou(QueryMode.next),
      apply: (items) {
        final ranked = items.rankFeed(pctrl.sessionSeed);
        pctrl.stateFor(_key).append(ranked);
      },
      onError: () => _showError('Failed to load more'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final states = pctrl.stateFor(_key);
      return ItemsBuilder(
        scroller: widget.scroller,
        counter: states.length,
        isEmpty: states.isEmpty,
        isLoading: pctrl.anyLoading,
        isLoadingNext: pctrl.loadingMore.value,
        message: "There's no posts yet.",
        hasError: pctrl.error.value,
        builder: (ctx, idx) => LiveFeed(feed: states[idx]),
        onMore: _loadMore,
        onRefresh: pctrl.refreshPost,
        onRetry: () => _loadInit(true),
      );
    });
  }

  void _showError(String title) {
    if (!mounted) return;

    final errorMessage = pctrl.error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
