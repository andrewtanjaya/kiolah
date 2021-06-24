import 'package:flutter/material.dart';
import 'package:kiolah/services/auth.dart';
import 'package:kiolah/views/chatList.dart';
import 'package:kiolah/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();

  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailController.text, passwordController.text)
      .then((value){
        print("${value.email}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatList()));

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val!.isEmpty ? "Username must be filled" : null;
                        },
                      controller: userNameController,
                      decoration: textFieldInputDecoration("username")
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!) ? null : "Please provide valid email";
                        },
                        controller: emailController,
                        decoration: textFieldInputDecoration("email")
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val!.isEmpty ? "Password must be filled" : null;
                        },
                        controller: passwordController,
                        decoration: textFieldInputDecoration("password")
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text("Sign Up",
                    style: TextStyle(
                      fontSize: 17
                    ),),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text("Sign Up With Google",
                  style: TextStyle(
                    fontSize: 17
                  ),),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have account? "),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("SignIn Now", style: TextStyle(
                          decoration: TextDecoration.underline
                        ),),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}