import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/views/AddOrder/addOrder.dart';
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

  // navigation
  int _currentIndex = 0;
  var _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      MainHome(scrollController: _scrollController),
      AddOrder(),
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _scrollController.position.userScrollDirection ==
                    ScrollDirection.reverse
                ? 0
                : 59,
            child: child,
          );
        },
        child: BottomNavigationBar(
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
      ),
      body: _pages[_currentIndex],
    );
  }
}
