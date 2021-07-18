import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/DetailPreorder/detailPreorder.dart';
import 'package:kiolah/views/Home/components/header.dart';

class Body extends StatefulWidget {
  // final ScrollController scrollController;

  Body({
    Key? key,
    // required this.scrollController,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<PreOrder>? mainData;
  List<PreOrder> data = <PreOrder>[];
  DatabaseMethods db = new DatabaseMethods();
  var uname;
  var preOrderData;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      DatabaseMethods().getChatRooms(Constant.myName).then((val) {
        setState(() {
          totalPreorder = val.docs.length;
        });
      });
      DatabaseMethods().getUserByUsername(uname).then((val) {
        setState(() {
          imageUrl = val.docs[0]["photoUrl"];
          print(val.docs[0]["photoUrl"]);
        });
      });
      getAllData();
    });
  }

  getAllData() {
    db.getListPreorder(uname).then((val) {
      setState(() {
        preOrderData = val.docs.map((entry) => PreOrder(
            entry["preOrderId"],
            entry["title"],
            entry["owner"],
            entry["group"],
            entry["location"],
            entry["items"]
                .map((v) => Item(
                    v["foodId"].toString(),
                    v["name"],
                    v["description"],
                    v["count"],
                    double.parse(v["price"].toString()).toDouble(),
                    "--"))
                .toList()
                .cast<Item>(),
            DateTime.fromMillisecondsSinceEpoch(
                entry["duration"].seconds * 1000),
            entry["users"].toList().cast<String>(),
            // .map((v) => Account(
            //     v["userId"],
            //     v["email"],
            //     PaymentType(
            //         v["paymentType"]["ovo"], v["paymentType"]["bca"]),
            //     v["phoneNumber"],
            //     v["photoUrl"],
            //     v["username"],
            //     v["groups"].toList().cast<String>()))
            // .toList()
            // .cast<Account>(),
            entry["status"],
            entry["maxPeople"]));
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(preOrderData.toString());
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        mainData = preOrderData.toList().cast<PreOrder>();

        data = mainData!
            .where((element) => element.status != 'Completed')
            .toList();
        print('!****************************');
        print(data.length);
        print('!****************************');
      });
    });
  }

  // List<Group> groups = [
  //   Group(
  //     '1',
  //     'ganteng ganteng club',
  //     'para cogan',
  //     [
  //       '1',
  //       '2',
  //       '3',
  //     ],
  //     '0xFFEDB95E',
  //   ),
  //   Group(
  //     '2',
  //     'cantik cantik club',
  //     'para cantik girl',
  //     [
  //       '3',
  //       '4',
  //       '5',
  //     ],
  //     '0xFFED2C5B',
  //   ),
  //   Group(
  //     '3',
  //     'sultan club',
  //     'para sultan',
  //     [
  //       '1',
  //       '2',
  //       '3',
  //     ],
  //     '0xFF4EDBB0',
  //   ),
  // ];
  // ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getUserName();
    // _scrollController = widget.scrollController;
    // data = mainData!.where((element) => element.status != 'Completed').toList();
  }

  // var username;

  var totalPreorder = 0;
  var imageUrl = 'assets/user/2.png';

  var _currentButtonBarIndex = 0;
  void _onButtonBarTapped(int index) {
    setState(() {
      _currentButtonBarIndex = index;
      if (index == 0)
        data = mainData!
            .where((element) => element.status != 'Completed')
            .toList();
      if (index == 1)
        data = mainData!
            .where((element) => element.status == 'Completed')
            .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: colorMainWhite,
      width: size.width,
      child: Column(
        children: [
          // header
          Header(
            username: uname == null ? "loading" : uname,
            totalPreorder: totalPreorder,
            imageUrl: imageUrl,
          ),

          // button bar
          Container(
            // color: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            width: size.width,
            child: ButtonBar(
              buttonPadding: EdgeInsets.symmetric(vertical: 0.0),
              alignment: MainAxisAlignment.start,
              children: [
                Container(
                  // height: 10.0,
                  // color: Colors.pink,
                  child: TextButton(
                    onPressed: () {
                      _onButtonBarTapped(0);
                    },
                    child: Text(
                      'Ongoing',
                      style: GoogleFonts.poppins(
                        color: _currentButtonBarIndex == 0
                            ? colorMainBlue
                            : colorMainGray,
                        fontWeight: _currentButtonBarIndex == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _onButtonBarTapped(1);
                  },
                  child: Text(
                    'History',
                    style: GoogleFonts.poppins(
                      color: _currentButtonBarIndex == 1
                          ? colorMainBlue
                          : colorMainGray,
                      fontWeight: _currentButtonBarIndex == 1
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // alignment: Alignment.center,
            // color: Colors.green,
            // width: size.width,
            width: 350,
            height: (246.0 * data.length),
            // padding: EdgeInsets.symmetric(horizontal: 24.0),
            margin: EdgeInsets.all(0),
            child: Expanded(
              child: SizedBox(
                width: 350,
                height: (246.0 * data.length),
                child: ListView.separated(
                  // controller: _scrollController,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PreorderCard(
                      data: data[index],
                      kind: 'home',
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
