import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/promptDialog.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/DetailPreorder/components/body.dart';
import 'package:kiolah/views/Home/home.dart';

class ItemsPreorderList extends StatefulWidget {
  final Item data;
  final String id;
  final bool? canDelete;
  final int? itemIndex;
  final List<dynamic>? listItemsUI;
  final VoidCallback? onPressedDelete;

  const ItemsPreorderList({
    Key? key,
    required this.data,
    required this.id,
    this.canDelete,
    this.itemIndex,
    this.listItemsUI,
    this.onPressedDelete,
  }) : super(key: key);

  @override
  _ItemsPreorderListState createState() => _ItemsPreorderListState();
}

class _ItemsPreorderListState extends State<ItemsPreorderList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 400,
      height: 60,
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
              'x${widget.data.count}',
              overflow: TextOverflow.clip,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: colorMainBlack,
                fontSize: 10.0,
              ),
            ),
          ),
          Container(
            width: widget.canDelete != true ? 200 : 160,
            // color: Colors.green,
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            // color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    widget.data.name,
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
                    widget.data.description,
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
                    widget.data.price.toString(),
                  ),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: colorMainBlack,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.canDelete == true)
            Container(
              child: IconButton(
                icon: Icon(Icons.clear_rounded),
                color: colorError,
                onPressed: widget.onPressedDelete,
                // :)
                // delete preoder
              ),
            )
        ],
      ),
    );
  }
}
