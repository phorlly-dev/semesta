import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/loader.dart';

class ListGenerated extends StatelessWidget {
  final int counter;
  final Widget Function(int idx) builder;
  final bool isLoading, neverScrollable;
  final bool isEmpty;
  final String? textEmpty;
  final Future<void> Function() onRefresh;
  final ScrollController? scroller;

  const ListGenerated({
    super.key,
    required this.counter,
    required this.builder,
    required this.isLoading,
    this.isEmpty = false,
    this.scroller,
    this.neverScrollable = false,
    required this.onRefresh,
    this.textEmpty,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Loader();

    if (isEmpty && !isLoading) {
      return Center(child: Text(textEmpty ?? 'There are currently not yet.'));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          controller: scroller,
          physics: neverScrollable ? NeverScrollableScrollPhysics() : null,
          children: List.generate(counter, builder),
        ),
      ),
    );
  }
}
