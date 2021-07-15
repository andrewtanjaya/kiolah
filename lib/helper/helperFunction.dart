import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{

  static String SP_USER_LOGGED_IN_KEY = "ISLOGGEDIN";
  static String SP_USERNAME_KEY = "USERNAMEKEY";
  static String SP_EMAIL_KEY = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSP(bool isLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(SP_USER_LOGGED_IN_KEY, isLoggedIn);
  }

  static Future<bool> saveUsernameSP(String username) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(SP_USERNAME_KEY, username);
  }

  static Future<bool> saveEmailSP(String email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(SP_EMAIL_KEY, email);
  }

  static Future<bool?> getUserLoggedInSP() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(SP_USER_LOGGED_IN_KEY);
  }

  static Future<String?> getUsernameSP() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(SP_USERNAME_KEY);
  }

  static Future<String?> getEmailSP() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(SP_EMAIL_KEY);
  }

}