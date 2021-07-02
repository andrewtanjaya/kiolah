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

  signMeUp() {
    if (formKey.currentState!.validate()) {
      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
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
        setState(() {
          SignUp.isLoading = true;
        });

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.getUsernameSP().then((username) {
          Constant.myName = username.toString();
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatList()));
      });
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
}
