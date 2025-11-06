import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextInput extends StatelessWidget {
  final String name;
  final String? label, initValue;
  final Widget? prefixIcon, suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly, obscureText, autofocus;
  final int maxLines;
  final double spacing;
  final TextEditingController? controller;
  final void Function(String? value)? formedValue, onChanged;

  const TextInput({
    super.key,
    required this.name,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.initValue,
    this.formedValue,
    this.spacing = 6,
    this.autofocus = false,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacing),
      child: FormBuilderTextField(
        autofocus: autofocus,
        name: name,
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        initialValue: initValue,
        obscureText: obscureText,
        keyboardType: keyboardType,
        valueTransformer: formedValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
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
      ),
    );
  }
}
