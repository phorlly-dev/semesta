import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class DataForm extends StatelessWidget {
  final double spacing;
  final List<Widget> children;
  final bool scrollable;
  final AutovalidateMode? autovalidate;
  final GlobalKey<FormBuilderState> _formKey;
  const DataForm(
    this._formKey, {
    super.key,
    this.spacing = 12,
    this.autovalidate,
    this.children = const [],
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: scrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: autovalidate,
        child: DirectionY(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: children,
        ),
      ),
    );
  }
}
