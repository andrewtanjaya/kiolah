import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final double? height;
  const Background({
    Key? key,
    required this.child,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: height == null ? size.height : height,
      child: Stack(
        children: [
          child,
        ],
      ),
    );
  }
}
