import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class Inputable extends StatelessWidget {
  final String _name;
  final int? maxLength;
  final String? label, initValue, hint, counterText;
  final IconData? icon;
  final Widget? suffix;
  final Defo<String?, String?>? validator;
  final TextInputType keyboardType;
  final bool readOnly, obscureText, autofocus;
  final int maxLines;
  final TextEditingController? controller;
  final ValueChanged<String?>? formedValue, onChanged;
  final VoidCallback? onCompleted;
  final FocusNode? focusNode;
  const Inputable(
    this._name, {
    super.key,
    this.label,
    this.icon,
    this.suffix,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.initValue,
    this.formedValue,
    this.autofocus = false,
    this.onChanged,
    this.controller,
    this.onCompleted,
    this.focusNode,
    this.hint,
    this.counterText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      autofocus: autofocus,
      name: _name,
      controller: controller,
      onEditingComplete: onCompleted,
      onChanged: onChanged,
      readOnly: readOnly,
      initialValue: initValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      valueTransformer: formedValue,
      focusNode: focusNode,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.hintColor),
        labelText: label ?? toCapitalize(_name),
        prefixIcon: icon != null
            ? Icon(icon, color: context.hintColor, size: 20)
            : null,
        suffixIcon: suffix,
        counterText: counterText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A9EFF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
