import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:semesta/public/helpers/generic_helper.dart';

class DateTimeInput extends StatelessWidget {
  final InputType type;
  final DateTime? initValue;
  final double spacing;
  final String? lable;
  final String _name;
  final IconData? icon;
  final FormFieldValidator<DateTime?>? validator;
  final DatePickerEntryMode initDatePicker;
  final TimePickerEntryMode initTimePicker;

  const DateTimeInput(
    this._name, {
    super.key,
    this.type = InputType.date,
    this.initValue,
    this.spacing = 6,
    this.lable,
    this.validator,
    this.icon,
    this.initDatePicker = DatePickerEntryMode.calendarOnly,
    this.initTimePicker = TimePickerEntryMode.dialOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacing),
      child: FormBuilderDateTimePicker(
        name: _name,
        inputType: type,
        initialValue: initValue,
        validator: validator,
        initialEntryMode: initDatePicker,
        timePickerInitialEntryMode: initTimePicker,
        initialDatePickerMode: DatePickerMode.year,
        decoration: InputDecoration(
          labelText: lable ?? toCapitalize(_name),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }
}
