import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';

class UserMenuItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;

  const UserMenuItem({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.onPressed,
    this.color: colorWarning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Icon(
                icon,
                color: color,
                size: 26.0,
              ),
            ),
            SizedBox(width: 16.0),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: colorMainBlack,
                      ),
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.0,
                        color: colorMainGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              child: Icon(
                Icons.navigate_next_rounded,
                color: colorMainGray,
                size: 24.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
