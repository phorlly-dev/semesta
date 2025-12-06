import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:semesta/app/functions/format.dart';

class RadioGroupInput<T> extends StatelessWidget {
  final String name;
  final String? initValue, label;
  final IconData? icon;
  final double spacing;
  final List<FormBuilderFieldOption<T>> items;

  const RadioGroupInput({
    super.key,
    required this.name,
    this.initValue,
    required this.items,
    this.label,
    this.icon,
    this.spacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacing),
      child: FormBuilderRadioGroup(
        decoration: InputDecoration(
          labelText: label ?? toCapitalize(name),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(),
          ),
        ),
        name: name,
        initialValue: initValue,
        validator: FormBuilderValidators.required(),
        options: items,
      ),
    );
  }
}
