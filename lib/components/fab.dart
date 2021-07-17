import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/views/AddOrder/addOrder.dart';

class FAB extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const FAB({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FloatingActionButton.extended(
        backgroundColor: colorMainBlue,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddOrder()));
        },
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(icon),
        ),
        label: SizedBox(),
      ),
    );
  }
}
