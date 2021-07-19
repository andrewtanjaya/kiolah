import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';

class StatusButton extends StatelessWidget {
  final String status;
  const StatusButton({
    Key? key,
    required this.status,
  }) : super(key: key);

  Color getStatusColor(status) {
    var color;
    if (status.toLowerCase() == 'ongoing') {
      color = colorWarning;
    } else if (status.toLowerCase() == 'unpaid' ||
        status.toLowerCase() == 'canceled') {
      color = colorError;
    } else if (status.toLowerCase() == 'ordered') {
      color = colorMainBlue;
    } else {
      color = colorSuccess;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: getStatusColor(status),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6.0,
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: colorMainWhite,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
