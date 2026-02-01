import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/items_builder.dart';
import 'package:semesta/src/components/global/feed_threaded.dart';

class FeedsTab extends StatefulWidget {
  final ScrollController _scroller;
  const FeedsTab(this._scroller, {super.key});

  @override
  State<FeedsTab> createState() => _FeedsTabState();
}

class _FeedsTabState extends State<FeedsTab> {
  CachedState<FeedView> get _states => pctrl.stateFor(getKey());

  @override
  void initState() {
    pctrl.freeOldPosts();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    super.initState();
  }

  void _load({bool retry = false}) {
    final session = pctrl.sessionSeed;

    final fetch = pctrl.loadMoreForYou;
    void apply(List<FeedView> items) => _states.set(items.rankFeed(session));

    if (retry) {
      pctrl.retry(fetch: fetch, apply: apply);
    } else {
      pctrl.loadStart(
        fetch: fetch,
        apply: apply,
        onError: () => _showError('Failed to load data'),
      );
    }
  }

  Future<void> _loadMore() async {
    await pctrl.loadMore(
      fetch: () => pctrl.loadMoreForYou(QueryMode.next),
      apply: (items) {
        final ranked = items.rankFeed(pctrl.sessionSeed);
        _states.append(ranked);
      },
      onError: () => _showError('Failed to load more'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ItemsBuilder(
        scroller: widget._scroller,
        counter: _states.length,
        isEmpty: _states.isEmpty,
        isLoading: pctrl.anyLoading,
        isLoadingNext: pctrl.loadingMore.value,
        message: "There's no posts yet.",
        hasError: pctrl.error.value,
        onMore: _loadMore,
        onRefresh: () => pctrl.refreshPost,
        onRetry: () => _load(retry: true),
        builder: (ctx, idx) => SyncFeedThreaded(_states[idx]),
      );
    });
  }

  void _showError(String title) {
    if (!mounted) return;

    final errorMessage = pctrl.error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
