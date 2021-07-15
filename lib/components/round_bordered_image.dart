import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';

class RoundBorderedImage extends StatelessWidget {
  final String imageUrl;
  final Color colorBorder;
  final double size;

  const RoundBorderedImage({
    Key? key,
    required this.imageUrl,
    this.colorBorder: colorMainWhite,
    this.size: 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          width: 1.5,
          color: colorBorder,
        ),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          alignment: Alignment.center,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
