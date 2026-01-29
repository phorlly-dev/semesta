import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:semesta/src/widgets/sub/error_view.dart';
import 'package:semesta/src/widgets/sub/loading_animated.dart';
import 'package:semesta/src/widgets/sub/no_data_entries.dart';

class DataBinder extends StatelessWidget {
  final bool isLoading, isEmpty;
  final String? message, hasError;
  final Widget child;
  final VoidCallback? onRetry;
  const DataBinder({
    super.key,
    this.isLoading = false,
    this.isEmpty = false,
    this.message,
    required this.child,
    this.hasError,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: context.height,
        child: LoadingAnimated(cupertino: true),
      );
    } else if (isEmpty) {
      return NoDataEntries(message ?? "There's no data yet.");
    } else if (hasError != null) {
      return ErrorView(onRetry: onRetry, message: hasError);
    }

    return child;
  }
}
