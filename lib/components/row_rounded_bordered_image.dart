import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_bordered_image.dart';
import 'package:kiolah/etc/constants.dart';

class RowBorderedImage extends StatelessWidget {
  final String firstImageUrl;
  final String secondImageUrl;
  final String thirdImageUrl;
  final Color borderColor;
  final int count;
  final double width;

  const RowBorderedImage({
    Key? key,
    this.firstImageUrl: '',
    this.secondImageUrl: '',
    this.thirdImageUrl: '',
    this.borderColor: colorMainWhite,
    this.width: 132,
    required this.count,
  }) : super(key: key);

  getWidth() {
    if (this.count > 3) {
      return 88.0;
    } else if (count == 3) {
      return 64.0;
    } else if (count == 2) {
      return 48.0;
    } else {
      return 24.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      width: getWidth(),
      child: Stack(
        // alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          if (firstImageUrl != '')
            RoundBorderedImage(
              imageUrl: firstImageUrl,
              colorBorder: borderColor,
            ),
          if (secondImageUrl != '')
            Positioned(
              left: 20,
              child: RoundBorderedImage(
                imageUrl: secondImageUrl,
                colorBorder: borderColor,
              ),
            ),
          if (thirdImageUrl != '')
            Positioned(
              left: 40,
              child: RoundBorderedImage(
                imageUrl: thirdImageUrl,
                colorBorder: borderColor,
              ),
            ),
          if (count > 3)
            Positioned(
              left: 60,
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Center(
                  child: Text(
                    '+' + (count - 3).toString(),
                    style: GoogleFonts.poppins(
                      color: colorMainWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.0,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: colorMainGray,
                ),
              ),
            )
        ],
      ),
    );
  }
}
