import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DataForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List<Widget> children;
  final double spacing;
  final AutovalidateMode? autovalidate;

  const DataForm({
    super.key,
    required this.formKey,
    required this.children,
    this.spacing = 8,
    this.autovalidate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: FormBuilder(
        key: formKey,
        autovalidateMode: autovalidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: children,
        ),
      ),
    );
  }
}
