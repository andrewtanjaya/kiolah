import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/preOrder.dart';
import 'components/body.dart';

class DetailPreOrder extends StatefulWidget {
  // DetailPage({Key? key}) : super(key: key);
  final Future<dynamic> func;
  final PreOrder data;
  final String group;

  const DetailPreOrder({
    Key? key,
    required this.func,
    required this.data,
    required this.group,
  });

  @override
  _DetailPreOrderState createState() => _DetailPreOrderState();
}

class _DetailPreOrderState extends State<DetailPreOrder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorMainWhite,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colorMainBlack,
        ),
      ),
      body: Body(
          func: widget.func,
          toggle: () => {},
          data: widget.data,
          group: widget.group),
    );
  }
}
