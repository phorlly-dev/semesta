import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class GroupedOptions<T extends Object> extends StatelessWidget {
  final String _name;
  final String? label;
  final T? initValue;
  final IconData? icon;
  final List<FormBuilderFieldOption<T>> options;
  final ValueChanged<T?>? onChanged, onFormated;
  final Defo<T?, String?>? validate;
  const GroupedOptions(
    this._name, {
    super.key,
    this.initValue,
    this.label,
    this.icon,
    this.onChanged,
    this.onFormated,
    this.validate,
    this.options = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderRadioGroup<T>(
      decoration: InputDecoration(
        labelText: label ?? toCapitalize(_name),
        prefixIcon: icon != null
            ? Icon(icon, color: context.hintColor, size: 20)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(),
        ),
      ),
      name: _name,
      options: options,
      onChanged: onChanged,
      initialValue: initValue,
      valueTransformer: onFormated,
      validator: validate ?? FormBuilderValidators.required(),
    );
  }
}
