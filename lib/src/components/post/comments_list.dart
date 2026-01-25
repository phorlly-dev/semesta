import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/app/controllers/comment_controller.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/info/comment_card.dart';
import 'package:semesta/src/components/global/items_builder.dart';

class CommentsList extends StatefulWidget {
  final String _pid, _uid;
  const CommentsList(this._pid, this._uid, {super.key});

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  late final CommentController _ctrl;
  CachedState<Feed> get _states => _ctrl.stateFor(_key);
  String get _key => getKey(id: widget._pid, screen: Screen.detail);

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<CommentController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load({bool retry = false}) {
    void apply(List<Feed> items) => _states.assignAll(items);
    Future<List<Feed>> fetch() => _ctrl.loadPostComments(widget._pid);

    if (retry) {
      _ctrl.retry(fetch: fetch, apply: apply);
    } else {
      _ctrl.loadStart(
        fetch: fetch,
        apply: apply,
        onError: () => _showError('Failed to load data'),
      );
    }
  }

  Future<void> _handleMore() async {
    await _ctrl.loadMore(
      fetch: () => _ctrl.loadPostComments(widget._pid, QueryMode.next),
      apply: (items) => _states.assignAll(items),
      onError: () => _showError('Failed to load more'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ItemsBuilder(
        onMore: _handleMore,
        counter: _states.length,
        hasError: _ctrl.error.value,
        isEmpty: _states.isEmpty,
        isLoading: _ctrl.anyLoading,
        isLoadingNext: _ctrl.loadingMore.value,
        message: "There's no replies yet.",
        onRetry: () => _load(retry: true),
        builder: (_, index) => CommentCard(
          _states[index],
          uid: widget._uid,
          style: RenderStyle.reference,
        ),
      );
    });
  }

  void _showError(String title) {
    if (!mounted) return;

    final errorMessage = _ctrl.error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
