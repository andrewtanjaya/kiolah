import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/custom_dialog.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/UserItem.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/Home/home.dart';

class EditGroupDialog extends StatefulWidget {
  final dynamic group;
  const EditGroupDialog({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  _EditGroupDialogState createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  TextEditingController groupNameController = new TextEditingController();

  // yang deleted nanti ditarok disini
  late List<dynamic> members;
  late List<Widget> listMembersWidgets;

  // dummy data --> nanti lu tarik data member tarok di usernames aja
  List<dynamic> usernames = ['ganteng', 'babet', 'cantik'];
  // untuk nanti tau posisi user yang dihapus
  late List<dynamic> dummyUsernames;

  getMember() {
    DatabaseMethods()
        .getChatRoomsbyId(widget.group["chatRoomId"])
        .then((value) {
      setState(() {
        usernames = value["users"];
        dummyUsernames = usernames;
        usernames.forEach((element) {
          DatabaseMethods().getUserByUsername(element).then((val) {
            setState(() {
              listMembersWidgets.add(
                memberItem(
                    // email, username, photoUrl nanti ganti sesuai dengan data yang lu tarik
                    email: val.docs[0]["email"],
                    photoUrl: val.docs[0]["photoUrl"],
                    username: element),
              );
            });
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    dummyUsernames = usernames;
    members = <String>[];
    listMembersWidgets = <Widget>[];
    getMember();
  }

  String? groupNameValidator(value) {
    if (value.toString().length <= 0) return 'Group\'s name must be filled';
    if (value.toString().trim().length > 15)
      return 'Group\'s name must only contains 15 characters';
  }

  getChatRoomId(List<dynamic> users) {
    users.sort((a, b) {
      return a
          .substring(0, 1)
          .codeUnitAt(0)
          .compareTo(b.substring(0, 1).codeUnitAt(0));
    });
    String roomId = "";
    for (var i = 0; i < users.length; i++) {
      roomId += users[i];
      if ((i + 1) < users.length) {
        roomId += "_";
      }
    }
    return roomId;
  }

  // submit kelar
  submit() {
    if (formKey.currentState!.validate()) {
      var groupName = groupNameController.text.toString().trim();
      if (members.length != 0) {
        DatabaseMethods()
            .checkChatRoomID(getChatRoomId(dummyUsernames))
            .then((DocumentSnapshot val) {
          if (val.data() == null) {
            //bole
            DatabaseMethods()
                .getConversationMessage(widget.group["chatRoomId"])
                .then((value) {
              setState(
                () {
                  Map<String, dynamic> chatRoomMap = {
                    "groupName": groupName,
                    "users": dummyUsernames,
                    "chatRoomId": getChatRoomId(dummyUsernames)
                  };

                  var messages = value.docs.map((entry) {
                    return {
                      "message": entry["message"],
                      "sendBy": entry["sendBy"],
                      "timestamp": entry["timestamp"]
                    };
                  }).toList();
                  DatabaseMethods().addChatRoomUpdate(
                      context,
                      widget.group["chatRoomId"],
                      getChatRoomId(dummyUsernames),
                      chatRoomMap,
                      messages);
                  getMember();
                },
              );
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return CustomDialog(
                  title: 'Failed!',
                  description: 'Group with current members exists',
                  imageUrl: 'assets/emoji/slightly_frowning_face.png',
                  textButton: 'OK',
                );
              },
            );
          }
        });
      } else {
        DatabaseMethods()
            .updateChatRoomName(groupName, widget.group["chatRoomId"]);
        setState(() {});
        Navigator.pop(context);
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => Home()));
      }

      // showDialog(
      //   context: context,
      //   builder: (BuildContext dialogContext) {
      //     return CustomDialog(title: 'Groyu', description: description, imageUrl: imageUrl, textButton: textButton)();
      //   },
      // );
    }
  }

  final formKey = GlobalKey<FormState>();

  Widget memberItem({
    required String username,
    required String email,
    required String photoUrl,
    // required // List<dynamic>? userToken,
  }
      // bool? isAddedItem,
      ) {
    return Container(
      width: 270,
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Container(
          //   width: 36.0,
          //   height: 36.0,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(36.0),
          //     image: DecorationImage(
          //       image: AssetImage(
          //         'assets/user/user.jpeg',
          //       ),
          //       alignment: Alignment.center,
          //       fit: BoxFit.fitWidth,
          //     ),
          //   ),
          // ),
          Container(
            width: 36.0,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.0),
            ),
            child: Image.network(
              photoUrl.toString(),
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          // RoundBorderedImage(
          //   imageUrl: photoUrl.toString(),
          //   colorBorder: colorMainWhite,
          //   size: 36.0,
          // ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: colorMainBlack,
                ),
              ),
              Container(
                width: 100,
                child: Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                    color: colorMainGray,
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          // if (isAddedItem != true)
          Container(
            width: 40.0,
            height: 40.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              // color: colorMainBlue,
              // boxShadow: [
              //   BoxShadow(
              //     color: colorMainBlue.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 7,
              //     offset: Offset(0, 2), // changes position of shadow
              //   ),
              // ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: colorError,
              ),
              onPressed: () {
                members.add(username);
                // function delete sini ya bos :)
                var index = 0;
                setState(() {
                  dummyUsernames.forEach((element) {
                    ++index;
                    if (element == username) {
                      dummyUsernames.removeWhere((item) => item == username);
                      listMembersWidgets = [];
                      dummyUsernames.forEach((element) {
                        DatabaseMethods()
                            .getUserByUsername(element)
                            .then((val) {
                          setState(() {
                            listMembersWidgets.add(
                              memberItem(
                                  // email, username, photoUrl nanti ganti sesuai dengan data yang lu tarik
                                  email: val.docs[0]["email"],
                                  photoUrl: val.docs[0]["photoUrl"],
                                  username: element),
                            );
                          });
                        });
                      });
                    }
                  });

                  // usernames.removeWhere((e) => {
                  //       e == '1',
                  //     });
                });
                // members.add()

                // addMember(username);
              },
            ),
          ),
          // Container(
          //   width: 100,
          //   child: RoundButton(
          //     text: 'Add',
          //     onPressed: () {
          //       addMember(username);
          //     },
          //   ),
          // ),
          // Spacer(),
          // GestureDetector(
          //   onTap: () {
          //     sendNotif(userToken);
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     child: Text("Send"),
          //     decoration: BoxDecoration(
          //         color: Colors.yellow,
          //         borderRadius: BorderRadius.circular(15)),
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 360,
          height: 400,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Edit Group',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: colorMainBlack,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: TextInputContainer(
                        child: TextInputField(
                          controller: groupNameController,
                          validator: groupNameValidator,
                          maxLength: 15,
                          // icon: Icons.mail_outline_outlined,
                          hintText: 'Group Name',
                          onChanged: (value) => {},
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'MEMBERS',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: colorMainGray,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // color: Colors.green,
                      width: 360,
                      child: Expanded(
                        child: SizedBox(
                          height: 140,
                          child: ListView.separated(
                            itemCount: listMembersWidgets.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listMembersWidgets[index];
                            },
                            // physics: NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 0.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: 160,
                  child: RoundButton(
                    text: 'Save',
                    onPressed: () {
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
