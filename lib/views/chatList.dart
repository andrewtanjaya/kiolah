import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/authenticate.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/main.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/conversationScreen.dart';
import 'package:kiolah/views/search.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  AuthMethods _authMethods = new AuthMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream<QuerySnapshot>? chatRoomStream;

  getToken() {
    _firebaseMessaging.getToken().then((token) {
      databaseMethods.addToken(token, Constant.myId);
    });
  }

  deleteToken() {
    _firebaseMessaging.getToken().then((token) {
      List<dynamic> tokens = [token];
      databaseMethods.deleteToken(tokens, Constant.myId);
    });
  }

  showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });
    getToken();
  }

  Widget ChatRoomList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomItem(
                      username: snapshot.data!.docs[index]["chatRoomId"]
                          .toString()
                          .replaceAll("_", ","),
                      chatRoomId: snapshot.data!.docs[index]["chatRoomId"],
                    );
                  })
              : Container();
        });
  }

  getUserInfo() async {
    await HelperFunction.getUsernameSP().then((username) {
      Constant.myName = username.toString();
      databaseMethods.getChatRooms(Constant.myName).then((val) {
        setState(() {
          chatRoomStream = val;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hi " + Constant.myName),
          actions: [
            GestureDetector(
              onTap: () {
                deleteToken();
                _authMethods.signOut();
                HelperFunction.saveEmailSP("");
                HelperFunction.saveUserLoggedInSP(false);
                HelperFunction.saveUsernameSP("");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
        ),
        body: ChatRoomList());
  }
}

class ChatRoomItem extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomItem({required this.username, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: colorMainBlue,
                  borderRadius: BorderRadius.circular(40)),
              child: Text(username.substring(0, 1).toUpperCase()),
            ),
            SizedBox(
              width: 8,
            ),
            Text(username)
          ],
        ),
      ),
    );
  }
}
