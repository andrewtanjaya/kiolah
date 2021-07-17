import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/item.dart';

class ItemsPreorderList extends StatelessWidget {
  final Item data;

  const ItemsPreorderList({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 400,
      height: 60,
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 36.0,
            height: 36.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              // color: Colors.blue,
              border: Border.all(
                color: colorMainGray,
                width: 1.0,
              ),
            ),
            child: Text(
              'x${data.count}',
              overflow: TextOverflow.clip,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: colorMainBlack,
                fontSize: 10.0,
              ),
            ),
          ),
          Container(
            width: 192,
            // color: Colors.green,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            // color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    data.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: colorMainBlack,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    data.description,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: colorMainGray,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.yellow,
            width: 90,
            child: Text(
              'IDR ' +
                  toCurrencyString(
                    data.price.toString(),
                  ),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: colorMainBlack,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
