import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';

class RoundOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const RoundOutlinedButton({
    Key? key,
    this.text: 'Outlined Button',
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: size.width * .7,
      // color: colorMainGray,
      child: Container(
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: colorMainBlack,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            primary: colorMainBlue,
          ),
        ),
      ),
    );
  }
}
