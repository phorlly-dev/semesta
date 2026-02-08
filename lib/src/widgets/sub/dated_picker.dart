import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';

class DatedPicker extends StatelessWidget {
  final InputType type;
  final DateTime? initValue;
  final String? lable;
  final String _name;
  final IconData? icon;
  final DatePickerEntryMode initDatePicker;
  final TimePickerEntryMode initTimePicker;
  final FormFieldValidator<DateTime?>? validator;
  const DatedPicker(
    this._name, {
    super.key,
    this.type = InputType.date,
    this.initValue,
    this.lable,
    this.validator,
    this.icon,
    this.initDatePicker = DatePickerEntryMode.calendarOnly,
    this.initTimePicker = TimePickerEntryMode.dialOnly,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: _name,
      inputType: type,
      initialValue: initValue,
      validator: validator,
      initialEntryMode: initDatePicker,
      timePickerInitialEntryMode: initTimePicker,
      initialDatePickerMode: DatePickerMode.year,
      decoration: InputDecoration(
        labelText: lable ?? toCapitalize(_name),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: context.hintColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(),
        ),
      ),
    );
  }
}
