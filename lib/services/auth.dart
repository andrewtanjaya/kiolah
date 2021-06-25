import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/views/chatList.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Account? _userFromFirebaseUser(User? user){
    return user != null ? 
    Account(
      userId: user.uid, 
      email: user.email,
      paymentType: null,
      phoneNumber: null,
      photoUrl: user.photoURL,
      username: user.displayName
      ) : null; 
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user =  result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user =  result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      
      return await _auth.sendPasswordResetEmail(email: email);

    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      HelperFunction.saveEmailSP("");
      HelperFunction.saveUserLoggedInSP(false);
      HelperFunction.saveUsernameSP("");
      return await _auth.signOut();
      


    }catch(e){
      print(e.toString());
    }
  }

  Future<User?>signInWithGoogle(BuildContext context) async{
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await _googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
    UserCredential result = await _auth.signInWithCredential(credential);
    
    User? userDetail = result.user;

    if(result != null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatList()));
    }

    return userDetail;

  }

}