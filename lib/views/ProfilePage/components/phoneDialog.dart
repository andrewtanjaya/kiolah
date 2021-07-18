import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/services/database.dart';

class PhoneDialog extends StatefulWidget {
  // const PhoneDialog({Key? key}) : super(key: key);
  @override
  _PhoneDialogState createState() => _PhoneDialogState();
}

class _PhoneDialogState extends State<PhoneDialog> {
  final _mobileFormatter = NumberTextInputFormatter();
  final formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();

  var uname;
  Account? user = null;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      DatabaseMethods().getUserByUsername(uname).then((val) {
        setState(() {
          user = new Account(
            val.docs[0]["userId"],
            val.docs[0]["email"],
            (val.docs[0]["paymentType"]).toList().cast<String>(),
            val.docs[0]["phoneNumber"],
            val.docs[0]["photoUrl"],
            val.docs[0]["username"],
          );
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  submit() {
    if (formKey.currentState!.validate()) {
      var phoneNumber = phoneNumberController.text.toString().trim();
      DatabaseMethods().updateUserPhone(phoneNumber, uname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: 300,
        height: 220,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: colorMainBlack,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  maxLength: 15,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                    _mobileFormatter,
                  ],
                  decoration: InputDecoration(
                    // icon: Icon(Icons.phone_iphone),
                    hintText: "Phone Number",
                    // fillColor: colorMainBlack,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 120,
                height: 64,
                child: RoundButton(
                  text: 'Save',
                  onPressed: () {
                    submit();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('+');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ' ');
      if (newValue.selection.end >= 2) selectionIndex += 1;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
