import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/services/database.dart';
import 'package:http/http.dart' as http;

class PaymentDialog extends StatelessWidget {
  final double total;
  final List<dynamic> token;
  final String title;
  final String poid;
  final String ovo;
  final String bca;

  PaymentDialog(
      {Key? key,
      required this.total,
      required this.ovo,
      required this.bca,
      required this.title,
      required this.poid,
      required this.token})
      : super(key: key);

  List<dynamic> tokens = [""];

  Future<bool> sendNotif(List<dynamic>? userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": Constant.myName + " paid!",
        "body": Constant.myName + " has paid " + title + "preorder",
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          "key=AAAAiLizO94:APA91bEWcwJ29j50QC47EeqBZODGr87irZ1ywpmh6xEmjY5YNR3jcz_K2mnCVPqIVFPsY1PdCs6PuRAMKNW_t5xzcsMSJi0rJWCCT5jrSUX_uRdIo7klD5p4cHHAfwzJntYxhxSFwyZ9" // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: colorMainWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorMainBlack,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  child: Text(
                    'IDR ' + toCurrencyString(total.toString()),
                    style: GoogleFonts.poppins(
                      color: colorMainGray,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () => {
                              Clipboard.setData(
                                ClipboardData(
                                  text: ovo.toString(),
                                ),
                              ),
                            },
                            style: OutlinedButton.styleFrom(
                                primary: colorMainBlue),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48.0,
                                    height: 24.0,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      // color: Colors
                                      //     .purple,
                                    ),
                                    child: Image.asset(
                                      'assets/payment/ovo.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.green,
                                    child: Text(
                                      ovo.toString().replaceAllMapped(
                                          RegExp(r".{3}"),
                                          (match) => "${match.group(0)} "),
                                      style: GoogleFonts.poppins(
                                        color: colorMainGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => {
                              Clipboard.setData(
                                ClipboardData(
                                  text: bca.toString(),
                                ),
                              ),
                            },
                            style: OutlinedButton.styleFrom(
                                primary: colorMainBlue),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48.0,
                                    height: 24.0,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      // color: Colors
                                      //     .purple,
                                    ),
                                    child: Image.asset(
                                      'assets/payment/bca.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.green,
                                    child: Text(
                                      bca.toString().replaceAllMapped(
                                          RegExp(r".{3}"),
                                          (match) => "${match.group(0)} "),
                                      style: GoogleFonts.poppins(
                                        color: colorMainGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    'Don\'t forget to notify the owner after the payment.',
                    style: GoogleFonts.poppins(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                      color: colorMainGray,
                    ),
                  ),
                ),
                Container(
                  width: size.width * .3,
                  child: RoundButton(
                    onPressed: () {
                      sendNotif(token);
                      Navigator.of(context).pop();
                    },
                    text: 'Done',
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: -90,
          //   child: Image.asset(
          //     'assets/emoji/money.png',
          //     width: 120,
          //   ),
          // ),
        ],
      ),
    );
  }
}
