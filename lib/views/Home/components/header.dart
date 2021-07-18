import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/authenticate.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/ProfilePage/profilePage.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.username,
    required this.totalPreorder,
    required this.imageUrl,
  }) : super(key: key);

  final String username;
  final int totalPreorder;
  final String imageUrl;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  AuthMethods _authMethods = new AuthMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  deleteToken() {
    _firebaseMessaging.getToken().then((token) {
      print('--- Firebase token here ---');
      List<dynamic> tokens = [token];
      databaseMethods.deleteToken(tokens, Constant.myId);
      print(token);
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.pink,
      width: size.width,
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: Colors.blue,
            width: size.width - 150,
            height: size.height - 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey ${widget.username}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: colorMainBlack,
                    ),
                    children: [
                      TextSpan(text: 'You have '),
                      TextSpan(
                          text: '${widget.totalPreorder}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(text: ' ongoing preorder 🔥'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // deleteToken();
              // _authMethods.signOut();
              // HelperFunction.saveEmailSP("");
              // HelperFunction.saveUserLoggedInSP(false);
              // HelperFunction.saveUsernameSP("");
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => Authenticate()));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          // chatRoomId: widget.data.group,
                          )));
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // color: Colors.green,
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(widget.imageUrl),
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorMainGray,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            ),
          )
        ],
      ),
    );
  }
}
