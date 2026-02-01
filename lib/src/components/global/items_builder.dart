import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/occurred_error.dart';
import 'package:semesta/src/widgets/sub/empty_data.dart';

class ItemsBuilder extends StatefulWidget {
  final int counter;
  final IndexedWidgetBuilder builder;
  final bool isLoading, isLoadingNext, isEmpty, isGrid, isBreak;
  final AsDef? onRefresh;
  final ScrollController? scroller;
  final VoidCallback onMore;
  final VoidCallback? onRetry;
  final String? message, hasError;
  const ItemsBuilder({
    super.key,
    this.isGrid = false,
    this.isBreak = false,
    this.isEmpty = false,
    this.isLoading = false,
    this.isLoadingNext = false,
    this.onRetry,
    this.scroller,
    this.onRefresh,
    this.message,
    this.hasError,
    required this.onMore,
    required this.counter,
    required this.builder,
  });

  @override
  State<ItemsBuilder> createState() => _ItemsBuilderState();
}

class _ItemsBuilderState extends State<ItemsBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: widget.isGrid
          ? const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
          : const EdgeInsets.only(bottom: 16, top: 8),
      child: LazyLoadScrollView(
        scrollOffset: 180,
        onEndOfPage: widget.onMore,
        isLoading: widget.isLoadingNext,
        child: widget.onRefresh != null
            ? RefreshIndicator(
                onRefresh: () => widget.onRefresh!(),
                child: CustomScrollView(
                  controller: widget.scroller,
                  slivers: [
                    if (widget.isBreak)
                      SliverToBoxAdapter(child: BreakSection()),

                    if (widget.isLoading && widget.isEmpty)
                      SliverFillRemaining(child: AnimatedCard())
                    else if (widget.isEmpty && !widget.isLoading)
                      SliverFillRemaining(
                        child: EmptyData(
                          widget.message ?? "There's no data yet.",
                        ),
                      )
                    else if (widget.hasError != null)
                      SliverFillRemaining(
                        child: OccurredError(
                          onRetry: widget.onRetry,
                          message: widget.hasError,
                        ),
                      )
                    else if (widget.isGrid)
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          widget.builder,
                          childCount: widget.counter,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 4.2,
                          crossAxisSpacing: 4.2,
                          childAspectRatio: .89,
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          widget.builder,
                          childCount: widget.counter,
                        ),
                      ),
                  ],
                ),
              )
            : CustomScrollView(
                controller: widget.scroller,
                slivers: [
                  if (widget.isLoading && widget.isEmpty)
                    SliverFillRemaining(child: AnimatedCard())
                  else if (widget.isEmpty && !widget.isLoading)
                    SliverFillRemaining(
                      child: EmptyData(
                        widget.message ?? "There's no data yet.",
                      ),
                    )
                  else if (widget.hasError != null)
                    SliverFillRemaining(
                      child: OccurredError(
                        onRetry: widget.onRetry,
                        message: widget.hasError,
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        widget.builder,
                        childCount: widget.counter,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
