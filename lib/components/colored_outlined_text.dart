import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';

class ColoredOutlinedText extends StatelessWidget {
  final String text;
  final Color color;

  const ColoredOutlinedText({
    Key? key,
    required this.text,
    this.color: colorMainGray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: lighten(color, .3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: color,
              width: 2.0,
            ),
          ),
          elevation: 0,
        ),
        onPressed: () => {},
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: darken(color),
          ),
        ),
      ),
    );
  }
}
