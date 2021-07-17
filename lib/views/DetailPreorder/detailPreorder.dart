import 'package:flutter/material.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/preOrder.dart';
import 'components/body.dart';

class DetailPreOrder extends StatefulWidget {
  // DetailPage({Key? key}) : super(key: key);
  final PreOrder data;

  const DetailPreOrder({
    Key? key,
    required this.data,
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
        toggle: () => {},
        data: widget.data,
      ),
    );
  }
}
