import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class CardNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final FormFieldValidator validator;
  final ValueChanged<String>? onChanged;
  final bool? isNumberFormat;
  final int? maxLength;

  const CardNumberTextField({
    Key? key,
    required this.controller,
    this.icon,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.isNumberFormat,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      cursorColor: colorMainBlack,
      decoration: InputDecoration(
        icon: icon != null
            ? Icon(
                icon,
                color: colorMainBlack,
              )
            : null,
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
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        CreditCardFormatter(),
      ],
      controller: controller,
      maxLength: maxLength,
      keyboardType:
          isNumberFormat == true ? TextInputType.number : TextInputType.text,
    );
  }
}
