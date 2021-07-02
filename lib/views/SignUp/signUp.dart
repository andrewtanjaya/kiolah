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
import 'package:kiolah/views/chatList.dart';
import 'package:kiolah/widgets/widget.dart';

import 'components/background.dart';
import 'components/body.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  static bool isLoading = false;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // final formKey = GlobalKey<FormState>();

  // AuthMethods authMethods = new AuthMethods();
  // DatabaseMethods databaseMethods = new DatabaseMethods();

  // TextEditingController userNameController = new TextEditingController();
  // TextEditingController emailController = new TextEditingController();
  // TextEditingController passwordController = new TextEditingController();
  // TextEditingController passwordAgaincontroller = new TextEditingController();

  // String? emailValidator(val) {
  //   return RegExp(
  //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //           .hasMatch(val!)
  //       ? null
  //       : "Please provide valid email";
  // }

  // String? passwordValidator(val) {
  //   return val!.isEmpty || val.length < 6
  //       ? "Password should be at least 6 characters"
  //       : null;
  // }

  // String? passwordAgainValidator(val) {
  //   if (val!.isEmpty || val.length < 6) {
  //     return "Password should be at least 6 characters";
  //   }
  //   if (val != passwordController.text) {
  //     return "Password must be the same";
  //   }
  //   return null;
  // }

  // String? usernameValidator(val) {
  //   return val!.isEmpty ? "Username must be filled" : null;
  // }

  // signMeUp() {
  //   if (formKey.currentState!.validate()) {
  //     authMethods
  //         .signUpWithEmailAndPassword(
  //             emailController.text, passwordController.text)
  //         .then((value) {
  //       Map<String, String> userInfoMap = {
  //         "email": value.email.toString(),
  //         "paymentType": value.paymentType.toString(),
  //         "phoneNumber": value.phoneNumber.toString(),
  //         "photoUrl": value.photoUrl.toString(),
  //         "userId": value.userId.toString(),
  //         "username": userNameController.text
  //       };
  //       // save shared pref
  //       HelperFunction.saveUserLoggedInSP(true);
  //       HelperFunction.saveUsernameSP(userNameController.text);
  //       HelperFunction.saveEmailSP(emailController.text);
  //       setState(() {
  //         isLoading = true;
  //       });

  //       databaseMethods.uploadUserInfo(userInfoMap);
  //       HelperFunction.getUsernameSP().then((username) {
  //         Constant.myName = username.toString();
  //       });
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => ChatList()));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.white,
    );
    double height = appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      // body: SignUp.isLoading
      //     ? Container(
      //         child: Center(child: CircularProgressIndicator()),
      //       )
      body: Body(
        toggle: widget.toggle,
        height: height,
      ),
      // SingleChildScrollView(
      //     child: Container(
      //       height: MediaQuery.of(context).size.height - 50,
      //       alignment: Alignment.center,
      //       child: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Form(
      //               key: formKey,
      //               child: Column(
      //                 children: [
      //                   TextFormField(
      //                       validator: (val) {
      //                         return val!.isEmpty
      //                             ? "Username must be filled"
      //                             : null;
      //                       },
      //                       controller: userNameController,
      //                       decoration:
      //                           textFieldInputDecoration("username")),
      //                   TextFormField(
      //                       validator: (val) {
      //                         return RegExp(
      //                                     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //                                 .hasMatch(val!)
      //                             ? null
      //                             : "Please provide valid email";
      //                       },
      //                       controller: emailController,
      //                       decoration: textFieldInputDecoration("email")),
      //                   TextFormField(
      //                       obscureText: true,
      //                       validator: (val) {
      //                         return val!.isEmpty || val.length < 6
      //                             ? "Password should be at least 6 characters"
      //                             : null;
      //                       },
      //                       controller: passwordController,
      //                       decoration:
      //                           textFieldInputDecoration("password")),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 16,
      //             ),
      //             Container(
      //               alignment: Alignment.centerRight,
      //               child: Container(
      //                 padding:
      //                     EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //                 child: Text(
      //                   "Forgot Password?",
      //                   style: TextStyle(color: Colors.black),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 16,
      //             ),
      //             GestureDetector(
      //               onTap: () {
      //                 signMeUp();
      //               },
      //               child: Container(
      //                 alignment: Alignment.center,
      //                 width: MediaQuery.of(context).size.width,
      //                 padding: EdgeInsets.symmetric(vertical: 20),
      //                 decoration: BoxDecoration(
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey.withOpacity(0.3),
      //                         spreadRadius: 2,
      //                         blurRadius: 20,
      //                         offset: Offset(0, 10),
      //                       )
      //                     ],
      //                     color: Colors.yellow,
      //                     borderRadius: BorderRadius.circular(25)),
      //                 child: Text(
      //                   "Sign Up",
      //                   style: TextStyle(fontSize: 17),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 16,
      //             ),
      //             // Container(
      //             //   alignment: Alignment.center,
      //             //   width: MediaQuery.of(context).size.width,
      //             //   padding: EdgeInsets.symmetric(vertical: 20),
      //             //   decoration: BoxDecoration(
      //             //     boxShadow: [
      //             //       BoxShadow(
      //             //         color: Colors.grey.withOpacity(0.3),
      //             //         spreadRadius: 2,
      //             //         blurRadius: 20,
      //             //         offset: Offset(0, 10),
      //             //       )
      //             //     ],
      //             //     color: Colors.white,
      //             //     borderRadius: BorderRadius.circular(25)
      //             //   ),
      //             //   child: Text("Sign Up With Google",
      //             //   style: TextStyle(
      //             //     fontSize: 17
      //             //   ),),
      //             // ),
      //             // SizedBox(height: 16,),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text("Already Have account? "),
      //                 GestureDetector(
      //                   onTap: () {
      //                     widget.toggle();
      //                   },
      //                   child: Container(
      //                     padding: EdgeInsets.symmetric(vertical: 8),
      //                     child: Text(
      //                       "SignIn Now",
      //                       style: TextStyle(
      //                           decoration: TextDecoration.underline),
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
    );
  }
}
