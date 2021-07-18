import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';

class AddHeader extends StatelessWidget {
  final String firstText;
  final String secondText;
  const AddHeader({
    Key? key,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              firstText,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: colorMainBlack,
              ),
            ),
          ),
          FittedBox(
            // width: ,
            // color: Colors.pink,
            child: Text(
              secondText,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: colorMainBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
