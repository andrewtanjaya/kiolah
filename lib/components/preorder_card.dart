import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/row_rounded_bordered_image.dart';
import 'package:kiolah/components/status_button.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/DetailJoinPreorder/detailJoinPreoder.dart';
import 'package:kiolah/views/DetailPreorder/detailPreorder.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'colored_outlined_text.dart';
import 'icon_text.dart';

class PreorderCard extends StatefulWidget {
  final PreOrder data;
  // final String kind;
  final VoidCallback? onPressed;

  PreorderCard({
    Key? key,
    required this.data,
    // required this.kind,
    this.onPressed,
    // required this.title,
    // required this.owner,
    // required this.duration,
    // required this.imagesUrl,
    // required this.status,
    // required this.location,
    // required this.food,
    // required this.group,
  }) : super(key: key);

  @override
  _PreorderCardState createState() => _PreorderCardState();
}

class _PreorderCardState extends State<PreorderCard> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot? searchSnapshot;
  late List<Account> users;
  late QuerySnapshot owner;
  var groupName;

  getGroupName() {
    databaseMethods
        .getGroupById(widget.data.group)
        .then((DocumentSnapshot val) {
      print('!!!!!!!!!!!!!!!!!!!!!');
      print(widget.data.group);
      groupName = val.get('groupName');
      print('!!!!!!!!!!!!!!!!!!!!!');
    });
  }

  @override
  void initState() {
    super.initState();
    users = <Account>[];
    initiateSearch();
    getGroupName();
  }

  initiateSearch() {
    print("DUARRRRR");
    print(widget.data.users);
    widget.data.users.forEach((element) {
      databaseMethods.getUserByUsername(element).then((val) {
        setState(() {
          users.add(
            new Account(
              val.docs[0]["userId"],
              val.docs[0]["email"],
              (val.docs[0]["paymentType"]).toList().cast<String>(),
              val.docs[0]["phoneNumber"],
              val.docs[0]["photoUrl"],
              val.docs[0]["username"],
            ),
          );
          // users.add(val);
          // if (searchSnapshot!.docs[0]["username"] == Constant.myName) {
          //   searchSnapshot = null;
          // }
          print(users[0].photoUrl);
        });
      });
    });
  }

  //   // databaseMethods.getUserByUsername(widget.data.owner).then((val) {
  //   //   setState(() {
  //   //     owner = val;
  //   //     // if (searchSnapshot!.docs[0]["username"] == Constant.myName) {
  //   //     //   searchSnapshot = null;
  //   //     // }
  //   //   });
  //   // });
  // }

  // onTapFunction() {
  //   // var type = widget.kind.toString().toLowerCase();
  //   // if (type == 'home') {
  //   //   Navigator.push(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //       builder: (context) => DetailPreOrder(
  //   //         data: widget.data,
  //   //       ),
  //   //     ),
  //   //   );
  //   // } else if (type == 'explore') {
  //   //   Navigator.push(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //       builder: (context) => DetailJoinPreOrder(
  //   //           // data: widget.data,
  //   //           ),
  //   //     ),
  //   //   );
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: widget.onPressed,
        child: Container(
          width: 350,
          height: 230,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: lighten(colorMainGray, .2),
                spreadRadius: .2,
                blurRadius: 20,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: colorMainGray,
                    width: 200,
                    child: Text(
                      widget.data.title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: colorMainBlack,
                      ),
                    ),
                  ),
                  ColoredOutlinedText(
                    text: groupName == null ? "Loading" : groupName,
                    color: colorWarning,
                  )
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.more_horiz_outlined,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () => {print('mantap')},
                  // ),
                ],
              ),
              IconText(
                icon: Icons.person_rounded,
                text: widget.data.owner,
                color: colorMainGray,
                width: 250,
              ),
              Row(
                children: [
                  IconText(
                    icon: Icons.location_on_rounded,
                    text: widget.data.location,
                    color: colorMainGray,
                  ),
                  SizedBox(
                    child: Text(
                      '\u2022',
                      style: GoogleFonts.poppins(color: colorMainGray),
                    ),
                    width: 20.0,
                  ),
                  IconText(
                    icon: Icons.people_rounded,
                    text: widget.data.maxPeople.toString(),
                    color: colorMainGray,
                  ),
                ],
              ),
              Row(
                children: [
                  IconText(
                    icon: Icons.restaurant_rounded,
                    text: widget.data.items.length.toString() + ' items',
                    color: colorMainGray,
                  ),
                  SizedBox(
                    child: Text(
                      '\u2022',
                      style: GoogleFonts.poppins(color: colorMainGray),
                    ),
                    width: 20.0,
                  ),
                  IconText(
                    icon: Icons.schedule_rounded,
                    text: timeago.format(widget.data.duration),
                    color: colorMainGray,
                  ),
                ],
              ),
              widget.data.users.length != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            RowBorderedImage(
                              borderColor: colorMainWhite,
                              firstImageUrl: users.length > 0
                                  ? users[0].photoUrl.toString()
                                  : '',
                              secondImageUrl: users.length > 1
                                  ? users[1].photoUrl.toString()
                                  : '',
                              thirdImageUrl: users.length > 2
                                  ? users[2].photoUrl.toString()
                                  : '',
                              count: widget.data.users.length,
                            ),
                          ],
                        ),
                        StatusButton(status: widget.data.status),
                      ],
                    )
                  : Text("-")
            ],
          ),
        ),
      ),
    );
  }
}
