import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:semesta/src/widgets/sub/occurred_error.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/empty_data.dart';

class DataBinder extends StatelessWidget {
  final bool loading, isEmpty;
  final String? message, hasError;
  final Widget child;
  final VoidCallback? onRetry;
  const DataBinder({
    super.key,
    this.loading = false,
    this.isEmpty = false,
    this.message,
    required this.child,
    this.hasError,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? SizedBox(
              height: context.height,
              child: AnimatedLoader(cupertino: true),
            )
          : isEmpty
          ? EmptyData(message ?? "There's no data yet.")
          : hasError != null
          ? OccurredError(onRetry: onRetry, message: hasError)
          : child,
    );
  }
}
