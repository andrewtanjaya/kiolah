import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/components/custom_dialog.dart';
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
import 'package:kiolah/views/chatList.dart';
import '../signUp.dart';
import 'background.dart';

class Body extends StatefulWidget {
  final Function toggle;
  final double height;

  const Body({
    Key? key,
    this.height: 56,
    required this.toggle,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordAgaincontroller = new TextEditingController();

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

  String? passwordAgainValidator(val) {
    if (val!.isEmpty || val.length < 6) {
      return "Password should be at least 6 characters";
    }
    if (val != passwordController.text) {
      return "Password must be the same";
    }
    return null;
  }

  String? usernameValidator(val) {
    return val!.isEmpty ? "Username must be filled" : null;
  }

  showSuccessPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomDialog(
          title: 'Yay !',
          description: 'Your account have been successfuly made !',
          imageUrl: 'assets/emoji/paper_popper.png',
          textButton: 'OK',
        );
      },
    );
  }

  showFailedPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomDialog(
          title: 'Oops',
          description: 'Account with the inputted information already exists !',
          imageUrl: 'assets/emoji/slightly_frowning_face.png',
          textButton: 'OK',
        );
      },
    );
  }

  signMeUp() {
    if (formKey.currentState!.validate()) {
      String userId;
      // try {
      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        userId = value.userId.toString();
        Map<String, String> userInfoMap = {
          "email": value.email.toString(),
          "paymentType": value.paymentType.toString(),
          "phoneNumber": value.phoneNumber.toString(),
          "photoUrl": value.photoUrl.toString(),
          "userId": value.userId.toString(),
          "username": userNameController.text
        };

        // save shared pref
        HelperFunction.saveUserLoggedInSP(true);
        HelperFunction.saveUsernameSP(userNameController.text);
        HelperFunction.saveEmailSP(emailController.text);
        HelperFunction.saveUserIdSP(userId);
        setState(() {
          SignUp.isLoading = true;
        });

        databaseMethods.uploadUserInfo(userInfoMap, userId);
        HelperFunction.getUsernameSP().then(
          (username) {
            Constant.myName = username.toString();
          },
        );
        HelperFunction.getEmailSP().then(
          (email) {
            Constant.myEmail = email.toString();
          },
        );
        HelperFunction.getUserIDSP().then(
          (userid) {
            Constant.myId = userid.toString();
          },
        );
        Timer.run(() {
          showSuccessPopUp();
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatList()));
      }).onError((error, stackTrace) => showFailedPopUp());
    }
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
                children: [
                  LoginHeader(
                    title: 'Welcome to Kiolah!',
                    description: 'Insert your personal information to continue',
                  ),
                  // Flexible(child: Container()),
                  Expanded(child: Container()),
                  Container(
                    // color: Colors.blue,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextInputContainer(
                            child: TextInputField(
                              hintText: 'Username',
                              icon: Icons.person_outline_rounded,
                              controller: userNameController,
                              validator: usernameValidator,
                            ),
                          ),
                          TextInputContainer(
                            child: TextInputField(
                              hintText: 'Email',
                              icon: Icons.mail_outline_rounded,
                              controller: emailController,
                              validator: emailValidator,
                            ),
                          ),
                          TextInputContainer(
                            child: PasswordInputField(
                              hintText: 'Password',
                              // icon: Icons.mail_outline_rounded,
                              controller: passwordController,
                              validator: passwordValidator,
                            ),
                          ),
                          TextInputContainer(
                            child: PasswordInputField(
                              hintText: 'Password again',
                              // icon: Icons.mail_outline_rounded,
                              controller: passwordAgaincontroller,
                              validator: passwordAgainValidator,
                            ),
                          ),
                          RoundButton(
                            text: 'REGISTER',
                            onPressed: () => signMeUp(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Flexible(child: Container()),
                  Expanded(child: Container()),
                  RoundOutlinedButton(
                    text: 'ALREADY HAVE AN ACCOUNT ?',
                    onPressed: () {
                      widget.toggle();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // BuildContext oldDialogContext;

  // onDismiss() {
  //   if (oldDialogContext != null) {
  //     Navigator.of(oldDialogContext).pop();
  //   }
  //   this.oldDialogContext = null;
  // }

}

// Future<String> showYesNoAlertDialog({
//   @required BuildContext context,
//   @required String titleText,
//   @required String messageText,
// }) async {
//   // set up the buttons
//   final Widget yesButton = FlatButton(
//     onPressed: () => Navigator.pop(context, 'yes'),
//     child: const Text('Yes'),
//   );
//   final Widget noButton = FlatButton(
//     onPressed: () => Navigator.pop(context, 'no'),
//     child: const Text('No'),
//   );

//   // set up the AlertDialog
//   final alert = AlertDialog(
//     title: Text(titleText),
//     content: Text(messageText),
//     actions: [
//       yesButton,
//       noButton,
//     ],
//   );

//   // show the dialog
//   return showDialog(
//     context: context,
//     builder: (context) => alert,
//   );
// }
