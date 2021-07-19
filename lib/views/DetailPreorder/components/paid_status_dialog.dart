import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';

class PaidStatusDialog extends StatefulWidget {
  final PreOrder po;
  final String? owner;
  PaidStatusDialog({Key? key, required this.po, required this.owner})
      : super(key: key);

  @override
  _PaidStatusDialogState createState() => _PaidStatusDialogState();
}

class _PaidStatusDialogState extends State<PaidStatusDialog> {
  late List<dynamic> members;
  late List<Widget> listMembersWidgets;

  var payStatus = 'Unpaid';
  var payStatusList = ['Unpaid', 'Paid'];

  @override
  void initState() {
    super.initState();
    // payStatus = 'Unpaid';
    members = <String>[];
    listMembersWidgets = <Widget>[];
    widget.po.users.forEach((element) {
      DatabaseMethods()
          .getStatusTransaction(element, widget.po.preOrderId)
          .then((e) {
        if (element != widget.owner) {
          DatabaseMethods().getUserByUsername(element).then((val) {
            setState(() {
              print("####################");
              print(element + " " + widget.po.preOrderId);
              print(e.docs[0]["status"]);
              print("####################");
              listMembersWidgets.add(
                memberItem(
                    // email, username, photoUrl nanti ganti sesuai dengan data yang lu tarik
                    email: val.docs[0]["email"],
                    photoUrl: val.docs[0]["photoUrl"],
                    username: element,
                    status: e.docs[0]["status"]),
              );
            });
          });
        }
      });
    });
  }

  Widget memberItem({
    required String username,
    required String email,
    required String photoUrl,
    required String status,
    // required // List<dynamic>? userToken,
  }
      // bool? isAddedItem,
      ) {
    return Container(
      width: 270,
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Row(
        children: [
          // Container(
          //   width: 36.0,
          //   height: 36.0,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(36.0),
          //     image: DecorationImage(
          //       image: AssetImage(
          //         'assets/user/user.jpeg',
          //       ),
          //       alignment: Alignment.center,
          //       fit: BoxFit.fitWidth,
          //     ),
          //   ),
          // ),
          Container(
            width: 36.0,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.0),
            ),
            child: Image.network(
              photoUrl.toString(),
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          // RoundBorderedImage(
          //   imageUrl: photoUrl.toString(),
          //   colorBorder: colorMainWhite,
          //   size: 36.0,
          // ),
          SizedBox(width: 16.0),
          Container(
            // color: Colors.green,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: colorMainBlack,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
                      color: colorMainGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          // if (isAddedItem != true)
          Container(
            width: 100,
            // color: Colors.pink,
            child: DropdownButton<String>(
              value: status,
              // icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorMainBlack,
                fontSize: 14.0,
              ),
              underline: Container(
                height: 0,
                color: colorMainBlack,
              ),
              onChanged: (String? newValue) {
                setState(
                  () {
                    print(newValue);
                    status = newValue!;
                    DatabaseMethods()
                        .setTransaction(username, widget.po.preOrderId, status);
                    // preOrderStatus = newValue!;
                    // currentPreorderStatus = preOrderStatus;
                    // updateStatus();
                  },
                );
              },
              items:
                  payStatusList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: payStatus.toString().toLowerCase() == 'unpaid'
                          ? colorError
                          : colorSuccess,
                      fontSize: 14.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 350,
        height: 300,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: colorMainWhite,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Payment Status',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: colorMainBlack,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              // color: Colors.green,
              width: 360,
              child: Expanded(
                child: SizedBox(
                  height: 140,
                  child: ListView.separated(
                    itemCount: listMembersWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listMembersWidgets[index];
                    },
                    // physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0.0),
                  ),
                ),
              ),
            ),
            Container(
              child: RoundButton(
                text: 'Done',
                onPressed: () {
                  Navigator.pop(context);
                  print('mantap');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
