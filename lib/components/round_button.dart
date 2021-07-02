import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const RoundButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .7,
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          shape: StadiumBorder(),
          primary: colorMainBlue,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
