import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/widgets/data_binder.dart';

class ListGridView extends StatelessWidget {
  final int crossCount, counter;
  final BuilderCallback<int, Widget> builder;
  final bool neverScrollable, isLoading, isEmpty;
  final FutureCallback<void> onRefresh;
  final ScrollController? scroller;
  final String? message;
  const ListGridView({
    super.key,
    this.crossCount = 3,
    required this.counter,
    required this.builder,
    this.neverScrollable = false,
    this.isLoading = false,
    this.isEmpty = false,
    required this.onRefresh,
    this.scroller,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return DataBinder(
      isEmpty: isEmpty,
      isLoading: isLoading,
      message: message,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: GridView.builder(
            itemCount: counter,
            itemBuilder: (context, index) => builder(index),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: .89,
            ),
          ),
        ),
      ),
    );
  }
}
