import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double width;

  const IconText({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    this.width: 125,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: SizedBox(
            width: 20.0,
            child: Icon(
              icon,
              size: 20.0,
              color: color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            child: Container(
              width: width - 20.0,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
