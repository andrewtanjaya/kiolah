import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';

class PasswordInputField extends StatefulWidget {
  // const PasswordInputField({ Key? key }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator validator;

  const PasswordInputField({
    Key? key,
    required this.controller,
    required this.validator,
    this.hintText: 'Password',
  }) : super(key: key);

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: colorMainBlack,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.visibility),
          color: colorMainBlack,
          onPressed: _toggle,
        ),
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
        hintText: widget.hintText,
      ),
    );
  }
}
