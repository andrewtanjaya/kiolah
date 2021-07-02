import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/helper/authenticate.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/views/chatList.dart';
import 'package:google_fonts/google_fonts.dart';
import 'etc/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLoggedIn = false;

  @override
  void initState() {
    checkLoggedIn();
    super.initState();
  }

  checkLoggedIn() async {
    await HelperFunction.getUserLoggedInSP().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorMainBlue,
        scaffoldBackgroundColor: colorMainWhite,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        errorColor: colorError,
      ),
      home: isLoggedIn == true ? ChatList() : Authenticate(),
    );
  }
}

class BlankScreen extends StatefulWidget {
  const BlankScreen({Key? key}) : super(key: key);

  @override
  _BlankScreenState createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
