import 'package:flutter/widgets.dart';
import 'package:semesta/ui/widgets/loader.dart';
import 'package:semesta/ui/widgets/no_data_entries.dart';

class DataBinder extends StatelessWidget {
  final bool isLoading, isEmpty;
  final String? message;
  final Widget child;
  const DataBinder({
    super.key,
    this.isLoading = false,
    this.isEmpty = false,
    this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(child: Loader()),
      );
    }

    if (isEmpty) {
      return NoDataEntries(message: message ?? "There's no data yet.");
    }

    return child;
  }
}
