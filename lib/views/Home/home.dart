import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/main.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/AddOrder/addOrder.dart';
import 'package:kiolah/views/ExplorePage/explorePage.dart';
import 'package:kiolah/views/Home/main_home.dart';
import 'package:kiolah/views/Login/signIn.dart';
import 'components/header.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  AuthMethods _authMethods = new AuthMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  // navigation
  int _currentIndex = 0;
  var _pages = [];

  getToken() {
    _firebaseMessaging.getToken().then((token) {
      print('--- Firebase token here ---');
      databaseMethods.addToken(token, Constant.myId);
      print(token);
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
      print('A new onMessageOpenedApp event was published!');
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
    _pages = [
      MainHome(scrollController: _scrollController),
      ExplorePage(scrollController: _scrollController),
      MainHome(scrollController: _scrollController),
      // Container(
      //   child: ListView(
      //     controller: _scrollController,
      //     children: [
      //       Center(child: Text('Second Page')),
      //     ],
      //   ),
      // ),
      // Container(
      //   child: ListView(
      //     controller: _scrollController,
      //     children: [
      //       Center(child: Text('Third Page')),
      //     ],
      //   ),
      // ),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          // AnimatedBuilder(
          //   animation: _scrollController,
          //   builder: (context, child) {
          //     return AnimatedContainer(
          //       duration: Duration(milliseconds: 300),
          //       height: _scrollController.position.userScrollDirection ==
          //               ScrollDirection.reverse
          //           ? 0
          //           : 59,
          //       child: child,
          //     );
          //   },
          //   child: BottomNavigationBar(
          BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            title: Text('User'),
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}
