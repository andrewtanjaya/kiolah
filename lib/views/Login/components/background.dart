import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final Widget child;
  final double height;
  Background({
    Key? key,
    required this.child,
    required this.height,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // nanti bisa masukkin background dibelakangnya
          widget.child,
        ],
      ),
    );
  }
}
