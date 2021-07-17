// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/views/Login/components/body.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    // get screen size
    AppBar appBar = AppBar(
      backgroundColor: Colors.white,
    );
    double height = appBar.preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Body(
        toggle: widget.toggle,
        height: height,
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
