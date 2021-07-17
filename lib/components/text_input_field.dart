import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final FormFieldValidator validator;
  final ValueChanged<String>? onChanged;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      cursorColor: colorMainBlack,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: colorMainBlack,
        ),
        hintText: hintText,
        focusColor: colorMainBlack,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorMainBlack),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorMainBlack),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorMainBlack),
        ),
      ),
      controller: controller,
    );
  }
}
