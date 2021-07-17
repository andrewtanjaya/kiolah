import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/box_with_shadow.dart';
import 'package:kiolah/components/colored_outlined_text.dart';
import 'package:kiolah/components/icon_text.dart';
import 'package:kiolah/components/item_preorder_list.dart';
import 'package:kiolah/components/payment_dialog.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/row_rounded_bordered_image.dart';
import 'package:kiolah/components/status_button.dart';
import 'package:kiolah/components/two_text_inline.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/functions.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/views/Home/components/background.dart';
import 'package:kiolah/views/conversationScreen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class Body extends StatefulWidget {
  // Body({Key? key}) : super(key: key);
  final Function toggle;
  final double height;
  final PreOrder data;

  const Body({
    Key? key,
    this.height: 0,
    required this.toggle,
    required this.data,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int perPage = 3;
  int present = 0;
  List<Item> items = <Item>[];
  String showMoreButtonText = 'Show More';

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.data.items.length < perPage) {
        perPage = widget.data.items.length;
      }
      items.addAll(widget.data.items.getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  showMoreLessItems() {
    setState(() {
      if (items.length < widget.data.items.length) {
        items.addAll(
            widget.data.items.getRange(present, widget.data.items.length));
        showMoreButtonText = 'Show Less';
        present = widget.data.items.length;
      } else {
        items = [];
        items.addAll(
          widget.data.items.getRange(0, perPage),
        );
        showMoreButtonText = 'Show More';
        present = perPage;
      }
    });
  }

  getTotalPrice() {
    var price = 0.0;
    widget.data.items.forEach(
      (element) {
        price += element.price;
      },
    );
    return price;
  }

  var formatter = NumberFormat('# ### ### ###');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          // color: Colors.blue,
          child: Column(
            children: [
              BoxWithShadow(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          // color: Colors.blue,
                          child: Text(
                            widget.data.title,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: colorMainBlack,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                        Container(
                          child: StatusButton(status: widget.data.status),
                        )
                      ],
                    ),
                    SizedBox(height: 8.0),
                    TwoTextInline(
                      title: 'Owner',
                      text: widget.data.owner,
                      width: size.width - 64.0,
                    ),
                    SizedBox(height: 8.0),
                    TwoTextInline(
                      title: 'Location',
                      text: widget.data.location,
                      width: size.width - 64.0,
                    ),
                    SizedBox(height: 8.0),
                    TwoTextInline(
                      title: 'Duration',
                      text: timeago.format(widget.data.duration),
                      width: size.width - 64.0,
                    ),
                  ],
                ),
              ),
              // items
              FittedBox(
                child: BoxWithShadow(
                  width: size.width,
                  child: Container(
                    width: 400,
                    height: (perPage < widget.data.items.length)
                        ? ((60.0 * (present + 1) + (present + 1) * 10.0))
                        : ((60.0 * (items.length) + (items.length) * 12.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: ((60.0 * (items.length) +
                                (items.length) * 10.0)),
                            child: ListView.separated(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemsPreorderList(
                                  data: widget.data.items[index],
                                );
                              },
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 16.0),
                            ),
                          ),
                        ),
                        if (perPage < widget.data.items.length)
                          TextButton(
                            onPressed: () => {
                              showMoreLessItems(),
                            },
                            child: Text(
                              showMoreButtonText,
                              style: GoogleFonts.poppins(
                                color: colorMainBlue,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 2.0),
              BoxWithShadow(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ColoredOutlinedText(
                      text: widget.data.group,
                      color: colorMainBlue,
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.blue,
                    )),
                    // RowBorderedImage(
                    //   borderColor: colorMainWhite,
                    //   firstImageUrl: widget.data.users.length > 0
                    //       ? widget.data.users[0].photoUrl.toString()
                    //       : '',
                    //   secondImageUrl: widget.data.users.length > 1
                    //       ? widget.data.users[1].photoUrl.toString()
                    //       : '',
                    //   thirdImageUrl: widget.data.users.length > 2
                    //       ? widget.data.users[2].photoUrl.toString()
                    //       : '',
                    //   count: widget.data.users.length,
                    // ),
                  ],
                ),
              ),
              if (widget.data.status.toLowerCase() != 'completed')
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                              color: colorMainGray,
                            ),
                          ),
                          Text(
                            'IDR ' +
                                toCurrencyString(getTotalPrice().toString()),
                            style: GoogleFonts.poppins(
                              color: colorMainBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      // RoundButton(
                      //   text: 'Pay',
                      //   onPressed: () => {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return PaymentDialog(
                      //           bca: widget.data.users[0].paymentType!.bca
                      //               .toInt(),
                      //           ovo: widget.data.users[0].paymentType!.ovo
                      //               .toInt(),
                      //           total: getTotalPrice(),
                      //         );
                      //       },
                      //     )
                      //   },
                      //   color: colorSuccess,
                      // ),
                    ],
                  ),
                ),
              if (widget.data.status.toLowerCase() != 'completed')
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    color: colorMainGray,
                    height: 2.0,
                  ),
                ),
              TextButton.icon(
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                                chatRoomId: widget.data.group,
                              )))
                },
                icon: Icon(
                  Icons.chat_rounded,
                  color: colorMainGray,
                  size: 18.0,
                ),
                label: Text(
                  'Chat',
                  style: GoogleFonts.poppins(
                    color: colorMainGray,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
