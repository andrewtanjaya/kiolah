import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/icon_text.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/components/round_bordered_image.dart';
import 'package:kiolah/components/row_rounded_bordered_image.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/views/Home/components/background.dart';
import 'package:kiolah/views/Home/components/header.dart';
import 'package:kiolah/views/SignUp/components/body.dart';

class Home extends StatefulWidget {
  // Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  // informasi header
  var username = 'Adrian !';
  var totalPreorder = 3;
  var imageUrl = 'assets/user/2.png';

  // navigation
  int _currentIndex = 0;
  final List<Widget> _children = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  var _currentButtonBarIndex = 0;
  void _onButtonBarTapped(int index) {
    setState(() {
      _currentButtonBarIndex = index;
    });
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
      body: Container(
        color: colorMainWhite,
        width: size.width,
        height: size.height - 24.0,
        // height: size.height - 24.0,
        child: Column(
          children: [
            // header
            Header(
              username: username,
              totalPreorder: totalPreorder,
              imageUrl: imageUrl,
            ),
            // button bar
            Container(
              // color: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              width: size.width,
              child: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      _onButtonBarTapped(0);
                    },
                    child: Text(
                      'Ongoing',
                      style: GoogleFonts.poppins(
                        color: _currentButtonBarIndex == 0
                            ? colorMainBlue
                            : colorMainGray,
                        fontWeight: _currentButtonBarIndex == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _onButtonBarTapped(1);
                    },
                    child: Text(
                      'History',
                      style: GoogleFonts.poppins(
                        color: _currentButtonBarIndex == 1
                            ? colorMainBlue
                            : colorMainGray,
                        fontWeight: _currentButtonBarIndex == 1
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              // color: Colors.green,
              child: Expanded(
                child: SizedBox(
                  width: 350,
                  height: size.height - 320,
                  child: ListView.separated(
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PreorderCard(
                        duration: '2 months ago',
                        imagesUrl: [
                          'assets/user/user.jpeg',
                          'assets/user/user.jpeg',
                          // 'assets/user/user.jpeg',
                        ],
                        title: 'Mantappu',
                        owner: 'Adrian',
                        status: 'Deadline',
                        food: 'Ayam Goreng',
                        group: 'SLC',
                        location: 'Nasi goreng aremah',
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
