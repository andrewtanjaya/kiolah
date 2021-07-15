import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final String description;
  const LoginHeader({
    Key? key,
    this.title: 'Welcome Back!',
    this.description: "Enter your credential to continue",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: size.width,
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24),
          ),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
