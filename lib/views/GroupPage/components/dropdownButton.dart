import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/edit_group_dialog.dart';
import 'package:kiolah/etc/constants.dart';

class GroupDropdownButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const GroupDropdownButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: colorMainBlack,
        ),
      ),
    );
  }
}
