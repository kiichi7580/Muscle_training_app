import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    this.prefixIcon,
    required this.hintText,
    required this.textInputType,
  });

  final TextEditingController textEditingController;
  final bool isPass;
  final Icon? prefixIcon;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}

class MemoTextField extends StatelessWidget {
  const MemoTextField({
    super.key,
    required this.labelText,
    required this.textInputType,
    required this.textEditingController,
    this.initialValue = '',
    this.onChanged,
    this.isEnabled,
  });
  final String labelText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final String initialValue;
  final void Function(String)? onChanged;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: isEnabled,
      controller: initialValue == ''
          ? textEditingController
          : TextEditingController(text: initialValue),
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      onChanged: onChanged,
    );
  }
}
