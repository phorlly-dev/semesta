import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/widgets/loader.dart';
import 'package:semesta/ui/widgets/no_data_entries.dart';

class DataBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final Stream<T>? stream;
  final T? initialData;
  final BuilderCallback<T, Widget> builder;
  final Widget? loading;
  final String? message;
  final ErrorCallback<Widget>? error;

  const DataBuilder({
    super.key,
    required this.builder,
    this.future,
    this.stream,
    this.initialData,
    this.loading,
    this.error,
    this.message,
  }) : assert(
         future != null || stream != null,
         'Either a future or a stream must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    Widget connectionBuilder(AsyncSnapshot<T> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loading ?? const Loader();
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return NoDataEntries(message: message ?? 'No data available');
      }

      if (snapshot.hasError) {
        return error?.call(snapshot.error!) ??
            Center(child: Text(snapshot.error.toString()));
      }

      return builder(snapshot.data as T);
    }

    if (stream != null) {
      return StreamBuilder<T>(
        stream: stream,
        initialData: initialData,
        builder: (ctx, snapshot) => connectionBuilder(snapshot),
      );
    } else {
      return FutureBuilder<T>(
        future: future,
        initialData: initialData,
        builder: (ctx, snapshot) => connectionBuilder(snapshot),
      );
    }
  }
}
