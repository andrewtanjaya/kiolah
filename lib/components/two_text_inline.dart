import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';

class TwoTextInline extends StatelessWidget {
  final String title;
  final String text;
  final Color titleColor;
  final Color textColor;
  final double width;
  final double fontSize;

  const TwoTextInline({
    Key? key,
    required this.title,
    required this.text,
    this.titleColor: colorMainGray,
    this.textColor: colorMainBlack,
    required this.width,
    this.fontSize: 14.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          // color: Colors.yellow,
          width: (width) / 2,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: titleColor,
              fontSize: fontSize,
            ),
          ),
        ),
        Container(
          // color: Colors.green,
          width: (width) / 2,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
