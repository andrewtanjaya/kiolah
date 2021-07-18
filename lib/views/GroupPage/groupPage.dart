import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/edit_group_dialog.dart';
import 'package:kiolah/components/fab.dart';
import 'package:kiolah/components/fab_extended.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/components/promptDialog.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/DetailJoinPreorder/detailJoinPreoder.dart';
import 'package:kiolah/views/GroupPage/components/dropdownButton.dart';

class GroupPage extends StatefulWidget {
  final dynamic group;
  GroupPage({Key? key, required this.group}) : super(key: key);
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late ScrollController _scrollController;
  var isFAB = false;
  DatabaseMethods db = new DatabaseMethods();

  List<PreOrder> data = <PreOrder>[];
  var uname;

  void initState() {
    super.initState();
    getUserName();

    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.addListener(() {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            setState(() {
              isFAB = true;
            });
          } else {
            setState(() {
              isFAB = false;
            });
          }
        });
      }
    });
  }

  ///
  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      getAllData();
    });
  }

  var preOrderData;
  List<PreOrder>? mainData;
  getAllData() {
    db.getPreorderGroup(widget.group["chatRoomId"]).then((val) {
      setState(() {
        preOrderData = val.docs.map((entry) => PreOrder(
              entry["preOrderId"],
              entry["title"],
              entry["owner"],
              entry["group"],
              entry["location"],
              entry["items"]
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
                  entry["duration"].seconds * 1000),
              entry["users"].toList().cast<String>(),
              entry["status"],
              entry["maxPeople"],
            ));
        mainData = preOrderData.toList().cast<PreOrder>();

        data = mainData!
            .where((element) => element.status != 'Completed')
            .toList();
        print('!****************************');
        print(data.length);
        print('!****************************');
      });
    });
  }

  ///

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorMainWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: colorMainBlack),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.green,
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'PREORDER LIST',
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: colorMainGray,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.group["groupName"].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: colorMainBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      // child: IconButton(
                      //   icon: Icon(
                      //     Icons.more_vert_rounded,
                      //     color: colorMainBlack,
                      //   ),
                      //   onPressed: () {
                      //     print('object');
                      //   },
                      // ),
                      child: DropdownButton<String>(
                        // value: dropdownValue,
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: colorMainBlack,
                        ),
                        iconSize: 24,
                        // elevation: 16,
                        style: GoogleFonts.poppins(
                          color: colorMainBlack,
                          fontWeight: FontWeight.w600,
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        // items: <Widget>[
                        //   GroupDropdownButton(text: 'Edit Details'),
                        //   GroupDropdownButton(text: 'Delete'),
                        // ].map<DropdownMenuItem<String>>((String value) {
                        //   return DropdownMenuItem<String>(
                        //     value: value,
                        //     child: Text(value),
                        //   );
                        // }).toList(),
                        items: [
                          DropdownMenuItem(
                            child: GroupDropdownButton(
                              text: 'Edit Details',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return EditGroupDialog(group: widget.group);
                                  },
                                );
                              },
                            ),
                            value: 'Edit Details',
                          ),
                          DropdownMenuItem(
                            child: GroupDropdownButton(
                              text: 'Delete',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return PromptDialog(
                                      title: 'Delete Group',
                                      description:
                                          'This action can\'t be undone.',
                                      primaryButtonText: 'DELETE',
                                      primaryButtonFunction: () {
                                        // delete sini bos :)
                                        print(widget.group["chatRoomId"]);
                                        DatabaseMethods().deleteChatRoom(widget
                                            .group["chatRoomId"]
                                            .toString());
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            value: 'Delete',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: size.width,
                height: (246.0 * data.length),
                child: Expanded(
                  child: SizedBox(
                    width: 350,
                    height: (246.0 * data.length),
                    child: ListView.separated(
                      // controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PreorderCard(
                          data: data[index],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailJoinPreOrder(data: data[index]),
                              ),
                            );
                          },
                        );
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isFAB
          ? FAB(icon: Icons.edit_rounded, onPressed: () {})
          : FABExtended(
              text: 'Add Preorder',
              onPressed: () {},
              icon: Icons.edit_rounded,
            ),
    );
  }
}
