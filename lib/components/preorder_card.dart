import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/row_rounded_bordered_image.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';

import 'icon_text.dart';

class PreorderCard extends StatefulWidget {
  final String title;
  final String owner;
  final String duration;
  final String location;
  final String food;
  final String group;
  final List<String> imagesUrl;
  final String status;

  PreorderCard({
    Key? key,
    required this.title,
    required this.owner,
    required this.duration,
    required this.imagesUrl,
    required this.status,
    required this.location,
    required this.food,
    required this.group,
  }) : super(key: key);

  @override
  _PreorderCardState createState() => _PreorderCardState();
}

class _PreorderCardState extends State<PreorderCard> {
  Color getStatusColor(status) {
    var color;
    if (widget.status.toLowerCase() == 'warning') {
      color = colorWarning;
    } else if (widget.status.toLowerCase() == 'deadline') {
      color = colorError;
    } else {
      color = colorSuccess;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: colorMainGray,
                spreadRadius: .5,
                blurRadius: 5,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: colorMainGray,
                    width: 200,
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: colorMainBlack,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    // color: Colors.blue,
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: lighten(colorMainGray, .3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: colorMainGray,
                            width: 2.0,
                          ),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => {},
                      child: Text(
                        'SLC',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: darken(colorMainGray),
                        ),
                      ),
                    ),
                  )
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.more_horiz_outlined,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () => {print('mantap')},
                  // ),
                ],
              ),
              IconText(
                icon: Icons.person_rounded,
                text: widget.owner,
                color: colorMainGray,
                width: 250,
              ),
              IconText(
                icon: Icons.location_on_rounded,
                text: widget.location,
                color: colorMainGray,
                width: 250,
              ),
              Row(
                children: [
                  IconText(
                    icon: Icons.restaurant_rounded,
                    text: widget.food,
                    color: colorMainGray,
                  ),
                  SizedBox(
                    child: Text(
                      '\u2022',
                      style: GoogleFonts.poppins(color: colorMainGray),
                    ),
                    width: 20.0,
                  ),
                  IconText(
                    icon: Icons.schedule_rounded,
                    text: widget.duration,
                    color: colorMainGray,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowBorderedImage(
                    borderColor: colorMainWhite,
                    firstImageUrl:
                        widget.imagesUrl.length > 0 ? widget.imagesUrl[0] : '',
                    secondImageUrl:
                        widget.imagesUrl.length > 1 ? widget.imagesUrl[1] : '',
                    thirdImageUrl:
                        widget.imagesUrl.length > 2 ? widget.imagesUrl[2] : '',
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: getStatusColor(widget.status),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      widget.status,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: colorMainWhite,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
