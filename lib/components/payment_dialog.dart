import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/etc/constants.dart';

class PaymentDialog extends StatelessWidget {
  final double total;
  final String ovo;
  final String bca;

  const PaymentDialog({
    Key? key,
    required this.total,
    required this.ovo,
    required this.bca,
  }) : super(key: key);

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
