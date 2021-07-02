import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/login_header.dart';
import 'package:kiolah/components/password_input_field.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/round_outlined_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/chatList.dart';
import 'package:kiolah/views/signUp.dart';
import 'package:kiolah/widgets/widget.dart';
// import 'package:kiolah/widgets/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  QuerySnapshot? snapUserInfo;

  signIn() {
    HelperFunction.saveEmailSP(emailController.text);
    if (formKey.currentState!.validate()) {
      databaseMethods.getUserByEmail(emailController.text).then(
        (value) {
          snapUserInfo = value;
          HelperFunction.saveUsernameSP(
              snapUserInfo!.docs[0]["username"].toString());
        },
      );

      String email = emailController.text;
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

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatList()));
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
    // get screen size
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        // color: Colors.pink,
        width: double.infinity,
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginHeader(
                title: "Welcome Back!",
                description: "Enter your credential to continue",
              ),
              Expanded(child: Container()),

              // SizedBox(height: size.height * .1),
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
                          icon: Icons.person_outline_rounded,
                          hintText: 'Username',
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
                      // SizedBox(height: size.height * .26),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              RoundOutlinedButton(
                text: "DONT\'T HAVE AN ACCOUNT YET ?",
                onPressed: () {
                  widget.toggle();
                  // print('hello');
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
    // return Scaffold(
    //   body: SingleChildScrollView(
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
    //                   // email
    //                   TextFormField(
    //                     validator: (val) {
    //                       return RegExp(
    //                                   r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //                               .hasMatch(val!)
    //                           ? null
    //                           : "Please provide valid email";
    //                     },
    //                     controller: emailController,
    //                     decoration: textFieldInputDecoration("email"),
    //                   ),

    //                   // password
    //                   TextFormField(
    //                       obscureText: true,
    //                       validator: (val) {
    //                         return val!.isEmpty || val.length < 6
    //                             ? "Password should be at least 6 characters"
    //                             : null;
    //                       },
    //                       controller: passwordController,
    //                       decoration: textFieldInputDecoration("password")),
    //                 ],
    //               ),
    //             ),
    //             // SizedBox(height: 16,),
    //             // Container(
    //             //   alignment: Alignment.centerRight,
    //             //   child: Container(
    //             //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //             //     child: Text(
    //             //       "Forgot Password?",
    //             //       style: TextStyle(
    //             //         color: Colors.black
    //             //       ),
    //             //     ),
    //             //   ),
    //             // ),
    //             SizedBox(
    //               height: 16,
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 signIn();
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
    //                   "Sign In",
    //                   style: TextStyle(fontSize: 17),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 16,
    //             ),
    //             // GestureDetector(
    //             //   onTap: (){
    //             //     authMethods.signInWithGoogle(context);
    //             //   },
    //             //   child: Container(
    //             //     alignment: Alignment.center,
    //             //     width: MediaQuery.of(context).size.width,
    //             //     padding: EdgeInsets.symmetric(vertical: 20),
    //             //     decoration: BoxDecoration(
    //             //       boxShadow: [
    //             //         BoxShadow(
    //             //           color: Colors.grey.withOpacity(0.3),
    //             //           spreadRadius: 2,
    //             //           blurRadius: 20,
    //             //           offset: Offset(0, 10),
    //             //         )
    //             //       ],
    //             //       color: Colors.white,
    //             //       borderRadius: BorderRadius.circular(25)
    //             //     ),
    //             //     child: Text("Sign In With Google",
    //             //     style: TextStyle(
    //             //       fontSize: 17
    //             //     ),),
    //             //   ),
    //             // ),
    //             // SizedBox(height: 16,),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text("Don't Have account? "),
    //                 GestureDetector(
    //                   onTap: () {
    //                     widget.toggle();
    //                   },
    //                   child: Container(
    //                     padding: EdgeInsets.symmetric(vertical: 8),
    //                     child: Text(
    //                       "Register Now",
    //                       style:
    //                           TextStyle(decoration: TextDecoration.underline),
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
    // );
  }
}
