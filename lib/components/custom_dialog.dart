import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/etc/constants.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String textButton;
  final String imageUrl;
  const CustomDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.textButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: colorMainWhite,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: colorMainBlack,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: colorMainBlack,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: size.width * .3,
                    child: RoundButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: textButton,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -60,
            child: Image.asset(
              imageUrl,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }
}
