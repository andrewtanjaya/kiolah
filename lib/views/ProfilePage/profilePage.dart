import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kiolah/helper/authenticate.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/services/database.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiolah/components/user_menu_item.dart';
import 'package:kiolah/etc/constants.dart';
import 'components/payment_type_dialog.dart';
import 'components/phoneDialog.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // nanti ambil dari sini bos gambarnya :)
  late File imageFile;
  var uname;
  Account? user = null;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      DatabaseMethods().getUserByUsername(uname).then((val) {
        setState(() {
          user = new Account(
            val.docs[0]["userId"],
            val.docs[0]["email"],
            (val.docs[0]["paymentType"]).toList().cast<String>(),
            val.docs[0]["phoneNumber"],
            val.docs[0]["photoUrl"],
            val.docs[0]["username"],
          );
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        uploadImageToFirebase();
      });
    }
  }

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

  Future uploadImageToFirebase() async {
    String fileName = basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference firebaseStorageRef =
        storage.ref().child('uploads/$fileName' + DateTime.now().toString());
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    uploadTask.then((res) => res.ref.getDownloadURL().then((value) {
          DatabaseMethods().updateUserPhoto(value, uname);
        }));
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
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
        toolbarHeight: 64.0,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: colorMainBlack,
            fontSize: 24.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          color: colorMainWhite,
          // height: size.height - 192,
          margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(96.0),
                        image: DecorationImage(
                          // image: FileImage(),
                          image: NetworkImage(user?.photoUrl ?? ""),
                          alignment: Alignment.center,
                          fit: BoxFit.fitWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          _getFromGallery();
                          // Navigator.of(context).pop();

                          // print(image);
                        }, // Handle your callback
                        child:
                            Ink(height: 100, width: 100, color: colorMainGray),
                      ),
                    ),
                    Container(
                      width: 350,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16.0, bottom: 2.0),
                      child: Text(
                        uname ?? 'username',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: colorMainBlack,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
                      alignment: Alignment.center,
                      child: Text(
                        user?.email ?? 'email',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorMainGray,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              // Expanded(child: Container()),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: colorMainGray.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    UserMenuItem(
                      icon: Icons.dialpad_rounded,
                      title: 'Phone Number',
                      description: 'Set your phone number',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return PhoneDialog();
                          },
                        );
                      },
                    ),
                    UserMenuItem(
                      icon: Icons.payments_rounded,
                      title: 'Payment Type',
                      description: 'Set your BCA, OVO account number',
                      color: colorMainBlue,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return PaymentTypeDialog();
                          },
                        );
                      },
                    ),
                    UserMenuItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      description: 'Sign out from current account',
                      color: colorMainGray,
                      onPressed: () {
                        deleteToken();
                        _authMethods.signOut();
                        HelperFunction.saveEmailSP("");
                        HelperFunction.saveUserLoggedInSP(false);
                        HelperFunction.saveUsernameSP("");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Authenticate()));
                      },
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
