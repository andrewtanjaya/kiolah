import 'package:flutter/material.dart';

class TextInputContainer extends StatelessWidget {
  final Widget child;
  const TextInputContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * .9,
      child: child,
      // color: Colors.green,
    );
  }
}
