import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/cardNumberFormatField.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';

class PaymentTypeDialog extends StatefulWidget {
//  PaymentTypeDialog({Key? key}) : super(key: key);

  @override
  PaymentTypeDialogState createState() => PaymentTypeDialogState();
}

class PaymentTypeDialogState extends State<PaymentTypeDialog> {
  TextEditingController ovoController = new TextEditingController();
  TextEditingController bcaController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? ovoValidator(value) {
    if (value.toString().trim().length > 17) {
      return 'Must be less than 18 digit';
    }
  }

  String? bcaValidator(value) {
    if (value.toString().trim().length > 10) {
      return 'Must be less than 11 digit';
    }
  }

  submit() {
    if (formKey.currentState!.validate()) {
      var ovo = ovoController.text.toString().trim();
      var bca = bcaController.text.toString().trim();
      print(ovo);
      print(bca);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 300,
        height: 300,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Type',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: colorMainBlack,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // color: Colors.pink,
                        image: DecorationImage(
                          image: AssetImage('assets/payment/ovo.png'),
                          alignment: Alignment.center,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.green,
                      // margin: EdgeInsets.symmetric(vertical: 16.0),
                      width: 200,
                      height: 64,
                      child: TextInputContainer(
                        child: CardNumberTextField(
                          controller: ovoController,
                          validator: ovoValidator,
                          isNumberFormat: true,

                          // icon: Icons.place_rounded,
                          maxLength: 17,
                          hintText: 'Input OVO',
                          onChanged: (value) => {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    // color: Colors.pink,
                    image: DecorationImage(
                      image: AssetImage('assets/payment/bca.png'),
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 64,
                  child: TextInputContainer(
                    child: CardNumberTextField(
                      controller: bcaController,
                      validator: bcaValidator,
                      // icon: Icons.place_rounded,
                      maxLength: 10,
                      hintText: 'Input BCA',
                      onChanged: (value) => {},
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 200,
                height: 60,
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
