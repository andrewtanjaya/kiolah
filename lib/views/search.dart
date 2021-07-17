import 'dart:convert';
// import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/conversationScreen.dart';

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

  initiateSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
        if (searchSnapshot!.docs[0]["username"] == Constant.myName) {
          searchSnapshot = null;
        }
      });
    });
  }

  addMember(String username) {
    users.add(username);
    print(users);
  }

  createChatRoom() {
    String chatRoomId = getChatRoomId(users);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };
    databaseMethods.addChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  chatRoomId: chatRoomId,
                )));
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
              );
            })
        : Container();
  }

  Widget SearchItem({required String username, required String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username),
              Text(email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              addMember(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Add"),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(15)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search Username",
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(46)),
                        width: 46,
                        height: 46,
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.search,
                        )),
                  )
                ],
              ),
            ),
            searchList(),
            GestureDetector(
              onTap: () {
                createChatRoom();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20)),
                child: Text("Create Group"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

getChatRoomId(List<String> users) {
  users.sort((a, b) {
    print(a);
    print(b);
    return a
        .substring(0, 1)
        .codeUnitAt(0)
        .compareTo(b.substring(0, 1).codeUnitAt(0));
  });
  String roomId = "";
  for (var i = 0; i < users.length; i++) {
    roomId += users[i];
    print(roomId);
    if ((i + 1) < users.length) {
      roomId += "_";
    }
  }
  return roomId;
}
