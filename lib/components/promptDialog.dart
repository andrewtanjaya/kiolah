import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/etc/constants.dart';

class PromptDialog extends StatefulWidget {
  final String title;
  final String description;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? primaryButtonFunction;

  PromptDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.primaryButtonFunction,
    this.secondaryButtonText,
  }) : super(key: key);

  @override
  _PromptDialogState createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        // width: 280,
        height: 180,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: colorMainBlack,
                ),
              ),
            ),
            Container(
              child: Text(
                widget.description,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: colorMainGray,
                  fontSize: 14.0,
                ),
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    // decoration: BoxDecoration(
                    //   borderRadius: StadiumBorder(),
                    // ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: colorMainBlue,
                      ),
                      child: Text(
                        widget.secondaryButtonText != null
                            ? widget.secondaryButtonText!
                            : 'CANCEL',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: colorMainGray,
                          fontSize: 14.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    width: 100,
                    child: RoundButton(
                      text: widget.primaryButtonText,
                      onPressed: widget.primaryButtonFunction,
                      isBold: true,
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     print('delete done!');
                  //   },

                  //   child: Text(
                  //     'CANCEL',
                  //     style: GoogleFonts.poppins(
                  //       fontWeight: FontWeight.bold,
                  //       color: colorMainBlue,
                  //       fontSize: 14.0,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
