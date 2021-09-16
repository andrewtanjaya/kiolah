import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/views/AddOrder/addOrder.dart';

class FABExtended extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;

  const FABExtended({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 160,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddOrder()));
        },
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AddOrder(),
        //   ),
        // );
        // },
        backgroundColor: colorMainBlue,
        icon: Icon(icon),
        label: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: colorMainWhite,
            ),
          ),
        ),
      ),
    );
  }
}
