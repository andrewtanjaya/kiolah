import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/row_rounded_bordered_image.dart';
import 'package:kiolah/components/status_button.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/views/DetailPreorder/detailPreorder.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'colored_outlined_text.dart';
import 'icon_text.dart';

class PreorderCard extends StatefulWidget {
  final PreOrder data;

  PreorderCard({
    Key? key,
    required this.data,
    // required this.title,
    // required this.owner,
    // required this.duration,
    // required this.imagesUrl,
    // required this.status,
    // required this.location,
    // required this.food,
    // required this.group,
  }) : super(key: key);

  @override
  _PreorderCardState createState() => _PreorderCardState();
}

class _PreorderCardState extends State<PreorderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPreOrder(
                data: widget.data,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: lighten(colorMainGray, .2),
                spreadRadius: .2,
                blurRadius: 20,
                offset: Offset(0, 3), // changes position of shadow
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
                      widget.data.title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: colorMainBlack,
                      ),
                    ),
                  ),
                  ColoredOutlinedText(
                    text: widget.data.group,
                    color: colorWarning,
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
                text: widget.data.owner,
                color: colorMainGray,
                width: 250,
              ),
              IconText(
                icon: Icons.location_on_rounded,
                text: widget.data.location,
                color: colorMainGray,
                width: 250,
              ),
              Row(
                children: [
                  IconText(
                    icon: Icons.restaurant_rounded,
                    text: widget.data.items[0].name,
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
                    text: timeago.format(widget.data.duration),
                    color: colorMainGray,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      RowBorderedImage(
                        borderColor: colorMainWhite,
                        firstImageUrl: widget.data.users.length > 0
                            ? widget.data.users[0].photoUrl.toString()
                            : '',
                        secondImageUrl: widget.data.users.length > 1
                            ? widget.data.users[1].photoUrl.toString()
                            : '',
                        thirdImageUrl: widget.data.users.length > 2
                            ? widget.data.users[2].photoUrl.toString()
                            : '',
                        count: widget.data.users.length,
                      ),
                    ],
                  ),
                  StatusButton(status: widget.data.status),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}