import 'dart:convert';

// import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_bordered_image.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/conversationScreen.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot? searchSnapshot;
  List<String> users = [Constant.myName];
  List<Account> addedUsers = [];
  Account? user;

  @override
  void initState() {
    super.initState();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(groupMemberController.text).then((val) {
      setState(() {
        searchSnapshot = val;
        if (searchSnapshot!.docs[0]["username"] == Constant.myName) {
          searchSnapshot = null;
        }
      });
    });
  }

  searchAddedUsers() {
    addedUsers = [];
    users.forEach((element) {
      databaseMethods.getUserByUsername(element).then((val) {
        setState(() {
          searchSnapshot = val;
          if (searchSnapshot!.docs[0]["username"] == Constant.myName) {
            searchSnapshot = null;
          } else {
            addedUsers.add(
              new Account(
                val.docs[0]["userId"],
                val.docs[0]["email"],
                (val.docs[0]["paymentType"]).toList().cast<String>(),
                val.docs[0]["phoneNumber"],
                val.docs[0]["photoUrl"],
                val.docs[0]["username"],
              ),
            );
            // print('!!!!!!!!!!!!!!!!!!!!!');
            // print(addedUsers[0].photoUrl);
            // print('!!!!!!!!!!!!!!!!!!!!!');
          }
        });
      });
    });
  }

  Future<bool> sendNotif(List<dynamic> userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": 'Title nihh',
        "body": 'body nihh',
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

  addMember(String username) {
    var alreadyContain = false;
    users.forEach((element) {
      if (element.toLowerCase() == username.toLowerCase())
        alreadyContain = true;
    });
    if (!alreadyContain) {
      users.add(username);
      print(users);
      searchAddedUsers();
    }
    // showAddedUsers();
  }

  createChatRoom() {
    // print('!!!!!!!!!!!!!!!!!!!!1');
    // print('users : $users');
    // print('!!!!!!!!!!!!!!!!!!!!1');
    // users.removeAt(0);
    // print('!!!!!!!!!!!!!!!!!!!!1');
    // print('users : $users');
    // print('!!!!!!!!!!!!!!!!!!!!1');
    String chatRoomId = getChatRoomId(users);
    var groupName = groupNameController.text.toString().trim();
    Map<String, dynamic> chatRoomMap = {
      "groupName": groupName,
      "users": users,
      "chatRoomId": chatRoomId
    };
    // print('!!!!!!!!!!!!!!!!!!!!1');
    // print('chatroomMap : $chatRoomMap');
    // print('!!!!!!!!!!!!!!!!!!!!1');

    // name groupName

    databaseMethods.addChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchItem(
                username: searchSnapshot!.docs[0]["username"].toString(),
                email: searchSnapshot!.docs[0]["email"].toString(),
                userToken: searchSnapshot!.docs[0]["token"],
                photoUrl: searchSnapshot!.docs[0]["photoUrl"],
              );
            },
            physics: NeverScrollableScrollPhysics(),
          )
        : Container();
  }

  Widget showAddedUsers() {
    // searchAddedUsers();
    return addedUsers.length != 0
        ? Container(
            child: SizedBox(
              height: addedUsers.length * 70,
              child: ListView.builder(
                itemCount: addedUsers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SearchItem(
                    username: addedUsers[index].username.toString(),
                    email: addedUsers[index].email.toString(),
                    // userToken: searchSnapshot!.docs[0]["token"],
                    photoUrl: addedUsers[index].photoUrl.toString(),
                    isAddedItem: true,
                  );
                },
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          )
        : Container();
    // } else {
    // Container(color: Colors.green);
    // }
  }

  // dulu
  // Widget SearchItem(
  //     {required String username,
  //     required String email,
  //     required List<dynamic> userToken}) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     child: Row(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(username),
  //             Text(email),
  //           ],
  //         ),
  //         Spacer(),
  //         GestureDetector(
  //           onTap: () {
  //             addMember(username);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             child: Text("Add"),
  //             decoration: BoxDecoration(
  //                 color: Colors.yellow,
  //                 borderRadius: BorderRadius.circular(15)),
  //           ),
  //         ),
  //         Spacer(),
  //         GestureDetector(
  //           onTap: () {
  //             print(userToken);
  //             sendNotif(userToken);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             child: Text("Send"),
  //             decoration: BoxDecoration(
  //                 color: Colors.yellow,
  //                 borderRadius: BorderRadius.circular(15)),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  //  baru
  Widget SearchItem({
    required String username,
    required String email,
    List<dynamic>? userToken,
    required String photoUrl,
    bool? isAddedItem,
  }) {
    return Container(
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
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                  color: colorMainGray,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          if (isAddedItem != true)
            Container(
              width: 40.0,
              height: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: colorMainBlue,
                boxShadow: [
                  BoxShadow(
                    color: colorMainBlue.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add_rounded,
                  color: colorMainWhite,
                ),
                onPressed: () {
                  addMember(username);
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
          //     print(userToken);
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

  final formKey = GlobalKey<FormState>();

  TextEditingController groupNameController = new TextEditingController();
  TextEditingController groupMemberController = new TextEditingController();

  String? groupNameValidator(value) {
    if (value.toString().length <= 0) return 'Group\'s name must be filled';
    if (value.toString().trim().length > 15)
      return 'Group\'s name must only contains 15 characters';
  }

  String? groupMemberValidator(value) {
    if (value.toString().length <= 0) return 'Group\'s member must be filled';
    // if (value.toString().trim().length > 15)
    //   return 'Group\'s name must only contains 15 characters';
  }

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
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          color: colorMainWhite,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ),
                    alignment: Alignment.centerLeft,
                    width: 120,
                    child: Text(
                      'Create',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: colorMainBlack,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ),
                    alignment: Alignment.centerLeft,
                    width: 240,
                    child: Text(
                      'New Group',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: colorMainBlack,
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextInputContainer(
                        child: TextInputField(
                          controller: groupNameController,
                          validator: groupNameValidator,
                          // icon: Icons.mail_outline_outlined,
                          hintText: 'Group Name',
                          onChanged: (value) => {},
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextInputContainer(
                                    child: TextInputField(
                                      controller: groupMemberController,
                                      validator: groupNameValidator,
                                      // icon: Icons.person_rounded,
                                      hintText: 'User\'s Username',
                                      onChanged: (value) => {},
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.search_rounded),
                                  onPressed: () {
                                    initiateSearch();
                                  },
                                ),
                              ],
                            ),
                          ),
                          searchList(),
                          if (addedUsers.length != 0)
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'Members',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: colorMainGray,
                                ),
                              ),
                            ),
                          showAddedUsers(),
                          RoundButton(
                            text: 'CREATE GROUP',
                            onPressed: () {
                              createChatRoom();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(List<String> users) {
  users.sort((a, b) {
    // print(a);
    // print(b);
    return a
        .substring(0, 1)
        .codeUnitAt(0)
        .compareTo(b.substring(0, 1).codeUnitAt(0));
  });
  String roomId = "";
  for (var i = 0; i < users.length; i++) {
    roomId += users[i];
    // print(roomId);
    if ((i + 1) < users.length) {
      roomId += "_";
    }
  }
  return roomId;
}
