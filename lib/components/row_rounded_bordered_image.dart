import 'package:flutter/material.dart';
import 'package:kiolah/components/round_bordered_image.dart';
import 'package:kiolah/etc/constants.dart';

class RowBorderedImage extends StatelessWidget {
  final String firstImageUrl;
  final String secondImageUrl;
  final String thirdImageUrl;
  final Color borderColor;
  final double width;

  const RowBorderedImage({
    Key? key,
    this.firstImageUrl: '',
    this.secondImageUrl: '',
    this.thirdImageUrl: '',
    this.borderColor: colorMainWhite,
    this.width: 134,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
        ],
      ),
    );
  }
}
