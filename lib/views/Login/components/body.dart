import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/components/login_header.dart';
import 'package:kiolah/components/password_input_field.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/round_outlined_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/Home/home.dart';
import 'package:kiolah/views/chatList.dart';

import 'background.dart';

class Body extends StatefulWidget {
  final Function toggle;
  final double height;

  const Body({
    Key? key,
    this.height: 56,
    required this.toggle,
  }) : super(key: key);
  // Body(this.toggle, this.height);
  // const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  QuerySnapshot? snapUserInfo;

  signIn() {
    HelperFunction.saveEmailSP(emailController.text.trim());
    if (formKey.currentState!.validate()) {
      databaseMethods.getUserByEmail(emailController.text.trim()).then(
        (value) {
          snapUserInfo = value;
          HelperFunction.saveUsernameSP(
              snapUserInfo!.docs[0]["username"].toString());
          HelperFunction.saveUserIdSP(
              snapUserInfo!.docs[0]["userId"].toString());
        },
      );

      String email = emailController.text.trim();
      String pass = passwordController.text;

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(email, pass).then(
        (value) {
          if (value != null) {
            HelperFunction.saveUserLoggedInSP(true);
            HelperFunction.getUsernameSP().then((username) {
              Constant.myName = username.toString();
            });
            HelperFunction.getUserIDSP().then((userid) {
              Constant.myId = userid.toString();
            });
            HelperFunction.getEmailSP().then((email) {
              Constant.myEmail = email.toString();
            });

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
        },
      );
    }
  }

  String? emailValidator(val) {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)
        ? null
        : "Please provide valid email";
  }

  String? passwordValidator(val) {
    return val!.isEmpty || val.length < 6
        ? "Password should be at least 6 characters"
        : null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: Background(
          height: size.height - widget.height - 24.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoginHeader(
                  title: "Welcome Back!",
                  description: "Enter your credential to continue",
                ),
                Expanded(child: Container()),
                Container(
                  width: size.width,
                  // color: Colors.cyan,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextInputContainer(
                          child: TextInputField(
                            controller: emailController,
                            validator: emailValidator,
                            icon: Icons.mail_outline_outlined,
                            hintText: 'Email',
                            onChanged: (value) => {},
                          ),
                        ),
                        TextInputContainer(
                          child: PasswordInputField(
                            controller: passwordController,
                            validator: passwordValidator,
                          ),
                        ),
                        RoundButton(
                          text: 'LOGIN',
                          onPressed: () => signIn(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
                RoundOutlinedButton(
                  text: "DON\'T HAVE AN ACCOUNT YET ?",
                  onPressed: () {
                    widget.toggle();
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    //     builder: (BuildContext context) =>
                    //         new SignUp(widget.toggle)));
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
