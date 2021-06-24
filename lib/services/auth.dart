import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiolah/model/account.dart';

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
      
      return await _auth.signOut();

    }catch(e){
      print(e.toString());
    }
  }

}