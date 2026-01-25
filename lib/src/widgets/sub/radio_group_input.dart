import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:semesta/public/helpers/generic_helper.dart';

class RadioGroupInput<T> extends StatelessWidget {
  final String _name;
  final String? initValue, label;
  final IconData? icon;
  final double spacing;
  final List<FormBuilderFieldOption<T>> items;

  const RadioGroupInput(
    this._name, {
    super.key,
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
          labelText: label ?? toCapitalize(_name),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(),
          ),
        ),
        name: _name,
        initialValue: initValue,
        validator: FormBuilderValidators.required(),
        options: items,
      ),
    );
  }
}
