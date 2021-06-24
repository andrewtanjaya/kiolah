import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/helper/authenticate.dart';
import 'package:kiolah/views/signIn.dart';
import 'package:kiolah/views/signUp.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
    );
  }
}
