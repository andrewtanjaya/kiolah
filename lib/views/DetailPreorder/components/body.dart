import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/box_with_shadow.dart';
import 'package:kiolah/components/colored_outlined_text.dart';
import 'package:kiolah/components/icon_text.dart';
import 'package:kiolah/components/item_preorder_list.dart';
import 'package:kiolah/components/payment_dialog.dart';
import 'package:kiolah/components/promptDialog.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/row_rounded_bordered_image.dart';
import 'package:kiolah/components/status_button.dart';
import 'package:kiolah/components/two_text_inline.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/functions.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/DetailPreorder/components/paid_status_dialog.dart';
import 'package:kiolah/views/Home/components/background.dart';
import 'package:kiolah/views/Home/home.dart';
import 'package:kiolah/views/conversationScreen.dart';
import 'package:kiolah/views/editPreOrder/editPreOrder.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;

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
  DatabaseMethods databaseMethods = new DatabaseMethods();

  int perPage = 3;
  int present = 0;
  // List<Item> items = <Item>[];
  String showMoreButtonText = 'Show More';
  List<dynamic> tokens = [""];

  late List<Widget> itemList;

  static bool isDelete = false;

  var currentPreorderStatus;

  updateStatus() {
    DatabaseMethods()
        .updatePreorderStatus(preOrderStatus, widget.data.preOrderId);
    tokens!.removeWhere((value) => value == null);
    print("##############################");
    print(tokens);
    print("##############################");
    sendNotif(tokens);
  }

  Future<bool> sendNotif(List<dynamic>? userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": widget.data.title + " status changed!",
        "body": widget.data.title + " status changed to " + preOrderStatus,
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          "key=AAAAiLizO94:APA91bEWcwJ29j50QC47EeqBZODGr87irZ1ywpmh6xEmjY5YNR3jcz_K2mnCVPqIVFPsY1PdCs6PuRAMKNW_t5xzcsMSJi0rJWCCT5jrSUX_uRdIo7klD5p4cHHAfwzJntYxhxSFwyZ9" // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  var preOrderData;

  @override
  void initState() {
    super.initState();
    preOrderStatus = widget.data.status;
    setState(() {
      // if (widget.data.items.length < perPage) {
      //   perPage = widget.data.items.length;
      // }
      // items.addAll(widget.data.items);
      // present = present + perPage;
    });

    getUserName();

    databaseMethods.getUserByUsername(widget.data.owner).then((val) {
      setState(() {
        owner = new Account(
          val.docs[0]["userId"],
          val.docs[0]["email"],
          (val.docs[0]["paymentType"]).toList().cast<String>(),
          val.docs[0]["phoneNumber"],
          val.docs[0]["photoUrl"],
          val.docs[0]["username"],
        );
        print("###########!!!#################");
        print(val.docs[0]["token"].toList());
        print("############!!!##############");
        tokens = tokens + (val.docs[0]["token"].toList());
        print("###########!!!#################");
        print(tokens);
        print("############!!!##############");
        // users.add(val);
        // if (searchSnapshot!.docs[0]["username"] == Constant.myName) {
        //   searchSnapshot = null;
        // }
        // print(users[0].photoUrl);
      });

      DatabaseMethods().getPreorder(widget.data.preOrderId).then(
        (val) {
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
          // print(val.docs[0]["title"]);
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
          setState(() {
            preOrderData = new PreOrder(
              val["preOrderId"],
              val["title"],
              val["owner"],
              val["group"],
              val["location"],
              val["items"]
                  .map((v) => Item(
                      v["foodId"],
                      v["name"],
                      v["description"],
                      v["count"],
                      double.parse(v["price"].toString()).toDouble(),
                      v["username"]))
                  .toList()
                  .cast<Item>(),
              DateTime.fromMillisecondsSinceEpoch(
                  val["duration"].seconds * 1000),
              val["users"].toList().cast<String>(),
              val["status"],
              val["maxPeople"],
            );
          });
        },
      );
    });

    currentPreorderStatus = widget.data.status;

    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(widget.data.items[0].username.toString());
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    itemList = [];
  }

  // showMoreLessItems() {
  //   setState(
  //     () {
  //       if (items.length < widget.data.items.length) {
  //         items.addAll(
  //             widget.data.items.getRange(present, widget.data.items.length));
  //         showMoreButtonText = 'Show Less';
  //         itemList = [];
  //         items.forEach((element) {
  //           //  ItemsPreorderList(
  //           //                       id: widget.data.preOrderId,
  //           //                       data: widget.data.items[index],
  //           //                       canDelete: (currentUser.username ==
  //           //                                   widget
  //           //                                       .data.items[index].username ||
  //           //                               currentUser!.userId == owner!.userId)
  //           //                           ? true
  //           //                           : false,
  //           itemList.add(
  //             new ItemsPreorderList(
  //               data: element,
  //               id: widget.data.preOrderId,
  //               canDelete: (currentUser.username == element.username ||
  //                       currentUser!.userId == owner!.userId)
  //                   ? true
  //                   : false,
  //               onPressedDelete: () {
  //                 showDialog(
  //                   context: context,
  //                   builder: (BuildContext dialogContext) {
  //                     return PromptDialog(
  //                         title: 'Delete Item ?',
  //                         description: 'This action can\'t be undone.',
  //                         primaryButtonText: 'DELETE',
  //                         primaryButtonFunction: () {
  //                           print('delete');
  //                           DatabaseMethods().updatePreorderItem(
  //                               Constant.myName,
  //                               widget.data.preOrderId,
  //                               element);
  //                           Navigator.pop(context);
  //                           // itemList.removeAt(index)
  //                           // Navigator.pushReplacement<void, void>(
  //                           //   context,
  //                           //   MaterialPageRoute<void>(
  //                           //     builder: (BuildContext context) => Home(),
  //                           //   ),
  //                           // );
  //                           // setState(() {
  //                           //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //                           //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //                           //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //                           //   print(widget.listItemsUI);
  //                           //   widget.listItemsUI!.removeAt(widget.itemIndex!);
  //                           //   print(widget.listItemsUI);
  //                           //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //                           //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //                           //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //                           // });
  //                         });
  //                   },
  //                 );
  //               },
  //             ),
  //           );
  //         });
  //         present = widget.data.items.length;
  //       } else {
  //         items = [];
  //         items.addAll(
  //           widget.data.items.getRange(0, perPage),
  //         );
  //         itemList = [];
  //         items.forEach((element) {
  //           itemList.add(
  //             new ItemsPreorderList(
  //               data: element,
  //               id: widget.data.preOrderId,
  //               canDelete: (currentUser.username == element.username ||
  //                       currentUser!.userId == owner!.userId)
  //                   ? true
  //                   : false,
  //             ),
  //           );
  //         });
  //         showMoreButtonText = 'Show More';
  //         present = perPage;
  //       }
  //     },
  //   );
  // }

  late Account owner;
  late Account currentUser;
  // :)
  late String preOrderStatus;
  List<String> status = ['Ongoing', 'Ordered', 'Completed'];
  var uname;
  List<dynamic>? tokenCurrent;
  late List<dynamic> dummyItems;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      DatabaseMethods().getUserByUsername(uname).then((val) {
        setState(() {
          currentUser = new Account(
            val.docs[0]["userId"],
            val.docs[0]["email"],
            (val.docs[0]["paymentType"]).toList().cast<String>(),
            val.docs[0]["phoneNumber"],
            val.docs[0]["photoUrl"],
            val.docs[0]["username"],
          );
          tokenCurrent = val.docs[0]["token"].toList();

          dummyItems = [];
          dummyItems = widget.data.items;
          int index = 0;
          dummyItems.forEach((element) {
            ++index;
            //  ItemsPreorderList(
            //                       id: widget.data.preOrderId,
            //                       data: widget.data.items[index],
            //                       canDelete: (currentUser.username ==
            //                                   widget
            //                                       .data.items[index].username ||
            //                               currentUser!.userId == owner!.userId)
            //                           ? true
            //                           : false,
            print("###########!!!#################");
            print(element);
            print("############!!!##############");
            itemList.add(
              itemPreorderList(
                  data: element,
                  id: widget.data.preOrderId,
                  canDelete: ((currentUser.username == element.username ||
                              currentUser!.userId == owner!.userId ||
                              widget.data.status.toLowerCase() == 'ongoing') &&
                          (widget.data.status.toLowerCase() != 'canceled'))
                      ? true
                      : false,
                  itemIndex: index - 1,
                  onPressedDelete: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PromptDialog(
                          title: 'Delete Item ?',
                          description: 'This action can\'t be undone.',
                          primaryButtonText: 'DELETE',
                          primaryButtonFunction: () {
                            print('delete');
                            DatabaseMethods().updatePreorderItem(
                              Constant.myName,
                              widget.data.preOrderId,
                              element,
                            );
                            Navigator.pop(context);
                            Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => Home(),
                              ),
                            );
                            //   DatabaseMethods()
                            //       .getPreorder(widget.data.preOrderId)
                            //       .then(
                            //     (val) {
                            //       print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //       print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //       print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //       // print(val.docs[0]["title"]);
                            //       print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //       print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //       print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //       setState(() {
                            //         var preOrderData;
                            //         preOrderData = new PreOrder(
                            //           val["preOrderId"],
                            //           val["title"],
                            //           val["owner"],
                            //           val["group"],
                            //           val["location"],
                            //           val["items"]
                            //               .map((v) => Item(
                            //                   v["foodId"],
                            //                   v["name"],
                            //                   v["description"],
                            //                   v["count"],
                            //                   double.parse(
                            //                           v["price"].toString())
                            //                       .toDouble(),
                            //                   v["username"]))
                            //               .toList()
                            //               .cast<Item>(),
                            //           DateTime.fromMillisecondsSinceEpoch(
                            //               val["duration"].seconds * 1000),
                            //           val["users"].toList().cast<String>(),
                            //           val["status"],
                            //           val["maxPeople"],
                            //         );
                            //         print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //         print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //         print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //         print(preOrderData.items.length);
                            //         print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //         print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //         print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            //         itemList = [];
                            //         preOrderData.items.forEach(
                            //           (e) => {
                            //             itemList.add(
                            //               itemPreorderList(
                            //                 data: element,
                            //                 id: widget.data.preOrderId,
                            //                 canDelete: (currentUser
                            //                                 .username ==
                            //                             element.username ||
                            //                         currentUser!.userId ==
                            //                             owner!.userId ||
                            //                         widget.data.status
                            //                                 .toLowerCase() ==
                            //                             'ongoing')
                            //                     ? true
                            //                     : false,
                            //                 itemIndex: index - 1,
                            //               ),
                            //             ),
                            //           },
                            //         );
                            //       });
                            //     },
                            //   ),
                            // );
                          },
                        );
                      },
                    );
                  }),
            );
            // new ItemsPreorderList(
            //   data: element,
            //   id: widget.data.preOrderId,
            //   canDelete: (currentUser.username == element.username ||
            //           currentUser!.userId == owner!.userId || widget.data.status.toLowerCase() == 'ongoing')
            //       ? true
            //       : false,
            //   listItemsUI: itemList,
            //   itemIndex: index - 1,
            //   key: Key("index_${index - 1}"),
            //   onPressedDelete: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext dialogContext) {
            //         return PromptDialog(
            //             title: 'Delete Item ?',
            //             description: 'This action can\'t be undone.',
            //             primaryButtonText: 'DELETE',
            //             primaryButtonFunction: () {
            //               print('delete');
            //               DatabaseMethods().updatePreorderItem(
            //                   Constant.myName,
            //                   widget.data.preOrderId,
            //                   element);
            //               Navigator.pop(context);
            //               // Navigator.pushReplacement<void, void>(
            //               //   context,
            //               //   MaterialPageRoute<void>(
            //               //     builder: (BuildContext context) => Home(),
            //               //   ),
            //               // );
            //               setState(() {
            //                 // print('!!!!!!!!!!!!!!!!');
            //                 // print('!!!!!!!!!!!!!!!!');
            //                 // print(index - 1);
            //                 // print('!!!!!!!!!!!!!!!!');
            //                 // print('!!!!!!!!!!!!!!!!');
            //                 // itemList.removeAt(index - 1);
            //                 this.itemList.removeWhere((element) =>
            //                     element.key == Key("index_${index - 1}"));
            //               });
            //               //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //               //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //               //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //               //   print(widget.listItemsUI);
            //               //   widget.listItemsUI!.removeAt(widget.itemIndex!);
            //               //   print(widget.listItemsUI);
            //               //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //               //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //               //   print("!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //               // });
            //             });
            //       },
            //     );
            //   },
            // ),
            // );
          });
        });
      });
    });
  }

  Widget itemPreorderList({
    required Item data,
    required String id,
    final bool? canDelete,
    final int? itemIndex,
    final List<dynamic>? listItemsUI,
    final VoidCallback? onPressedDelete,
    final bool? isOwner,
  }) {
    return Container(
      // color: Colors.green,
      width: 400,
      height: 90,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              data.username,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            // color: Colors.green,
            width: 400,
            // height: 105,
            child: Column(
              children: [
                Container(
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
                        width: canDelete != true ? 200 : 160,
                        // color: Colors.green,
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
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
                      if (canDelete == true)
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.clear_rounded),
                            color: colorError,
                            onPressed: onPressedDelete,
                            // print('delete');
                            // :)
                            // delete preoder
                          ),
                        ),
                    ],
                  ),
                ),
                // if (isOwner == true)
                //   Container(
                //     alignment: Alignment.centerRight,
                //     child: DropdownButton<String>(
                //       value: payStatusValue,
                //       // icon: const Icon(Icons.arrow_downward),
                //       iconSize: 24,
                //       elevation: 16,
                //       style: GoogleFonts.poppins(
                //         fontWeight: FontWeight.w600,
                //         color: colorMainBlue,
                //         fontSize: 12.0,
                //       ),
                //       underline: Container(
                //         height: 0,
                //         color: colorMainBlack,
                //       ),
                //       onChanged: (String? newValue) {
                //         setState(() {
                //           // preOrderStatus = newValue!;
                //           // currentPreorderStatus = preOrderStatus;
                //           // updateStatus();
                //         });
                //       },
                //       items: payStatus
                //           .map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget itemPreorderListDetail({
  //   required Item data,
  //   required String id,
  //   final bool? canDelete,
  //   final int? itemIndex,
  //   final List<dynamic>? listItemsUI,
  //   final VoidCallback? onPressedDelete,
  // }) {
  //   return
  // }

  getTotalPrice() {
    var price = 0.0;
    widget.data.items.forEach(
      (element) {
        if (element.username == uname) price += (element.price * element.count);
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
                          child: StatusButton(status: currentPreorderStatus),
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
              if (widget.data.items.length != 0)
                FittedBox(
                  child: BoxWithShadow(
                    width: size.width,
                    child: Container(
                      width: 400,
                      height: 90.0 * widget.data.items.length,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 80.0 * widget.data.items.length,
                              child: ListView.separated(
                                itemCount: widget.data.items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return itemList[index];
                                  // return ItemsPreorderList(
                                  //   id: widget.data.preOrderId,
                                  //   data: widget.data.items[index],
                                  //   canDelete: (currentUser.username ==
                                  //               widget
                                  //                   .data.items[index].username ||
                                  //           currentUser!.userId == owner!.userId)
                                  //       ? true
                                  //       : false,
                                  // );
                                },
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 8.0),
                              ),
                            ),
                          ),
                          // if (perPage < widget.data.items.length)
                          //   TextButton(
                          //     onPressed: () => {
                          //       showMoreLessItems(),
                          //     },
                          //     child: Text(
                          //       showMoreButtonText,
                          //       style: GoogleFonts.poppins(
                          //         color: colorMainBlue,
                          //         fontSize: 14.0,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),
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
                      if (currentUser!.userId != owner!.userId)
                        RoundButton(
                          text: 'Pay',
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PaymentDialog(
                                  title: widget.data.title,
                                  token: tokens,
                                  poid: widget.data.preOrderId,
                                  bca: owner!.paymentType![0].toString(),
                                  ovo: owner!.paymentType![1].toString(),
                                  total: getTotalPrice(),
                                );
                              },
                            ),
                          },
                          color: colorSuccess,
                        ),
                    ],
                  ),
                ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: colorMainGray,
                  height: 2.0,
                ),
              ),
              if (widget.data.status.toLowerCase() != 'canceled')
                if (currentUser!.userId == owner!.userId)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Change Status',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: colorMainBlack,
                            ),
                          ),
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: preOrderStatus,
                            // icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: colorMainBlue,
                              fontSize: 14.0,
                            ),
                            underline: Container(
                              height: 0,
                              color: colorMainBlack,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                preOrderStatus = newValue!;
                                currentPreorderStatus = preOrderStatus;
                                updateStatus();
                              });
                            },
                            items: status
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
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
              SizedBox(
                height: 8.0,
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
              ),
              if (currentUser!.userId == owner!.userId)
                SizedBox(
                  height: 12.0,
                ),
              if (currentUser!.userId == owner!.userId)
                TextButton(
                  onPressed: () => {
                    // edit payment status disini :)
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PaidStatusDialog(
                          owner: owner.username,
                          po: widget.data,
                          // token: tokens,
                          // bca: owner!.paymentType![0].toString(),
                          // ovo: owner!.paymentType![1].toString(),
                          // total: getTotalPrice(),
                        );
                      },
                    )
                  },
                  child: Text(
                    'Payment Status',
                    style: GoogleFonts.poppins(
                      color: colorMainGray,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // icon: Icon(
                  //   Icons.chat_rounded,
                  //   color: colorMainGray,
                  //   size: 18.0,
                  // ),
                ),
              if (currentUser!.userId == owner!.userId)
                SizedBox(
                  height: 12.0,
                ),
              if (currentUser!.userId == owner!.userId)
                TextButton(
                  onPressed: () => {
                    // edit preoder disini :)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditOrder(data: widget.data
                                // chatRoomId: widget.data.group,
                                )))
                  },
                  child: Text(
                    'Edit Preoder',
                    style: GoogleFonts.poppins(
                      color: colorMainGray,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // icon: Icon(
                  //   Icons.chat_rounded,
                  //   color: colorMainGray,
                  //   size: 18.0,
                  // ),
                ),

              if (currentUser!.userId == owner!.userId)
                SizedBox(
                  height: 24.0,
                ),
              if (currentUser!.userId == owner!.userId)
                TextButton(
                  onPressed: () {
                    // delete preoder disini :)

                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PromptDialog(
                          title: 'Cancel this order ?',
                          description: 'This action can\'t be undone.',
                          primaryButtonText: 'YES',
                          secondaryButtonText: 'NO',
                          primaryButtonFunction: () {
                            preOrderStatus = "Canceled";
                            updateStatus();
                            Navigator.pop(context);
                            setState(() {
                              currentPreorderStatus = preOrderStatus;
                            });
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'Cancel Preoder',
                    style: GoogleFonts.poppins(
                      color: colorError,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // icon: Icon(
                  //   Icons.chat_rounded,
                  //   color: colorMainGray,
                  //   size: 18.0,
                  // ),
                ),
              if (currentUser!.userId == owner!.userId) SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
