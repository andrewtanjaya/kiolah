import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/DetailJoinPreorder/detailJoinPreoder.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DatabaseMethods db = new DatabaseMethods();

  List<PreOrder> data = <PreOrder>[];
  var uname;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      getAllData();

      // tes la lu
      // db.getAvailPreorder(uname).then((val) {
      //   setState(() {
      //     preOrderData = val.docs.map((entry) => PreOrder(
      //           entry["preOrderId"],
      //           entry["title"],
      //           entry["owner"],
      //           entry["group"],
      //           entry["location"],
      //           entry["items"]
      //               .map((v) => Item(v["foodId"], v["name"], v["description"],
      //                   v["count"], double.parse(v["price"])))
      //               .toList()
      //               .cast<Item>(),
      //           DateTime.fromMillisecondsSinceEpoch(
      //               entry["duration"].seconds * 1000),
      //           entry["users"].toList().cast<String>(),
      //           // .map((v) => Account(
      //           //     v["userId"],
      //           //     v["email"],
      //           //     PaymentType(
      //           //         v["paymentType"]["ovo"], v["paymentType"]["bca"]),
      //           //     v["phoneNumber"],
      //           //     v["photoUrl"],
      //           //     v["username"],
      //           //     v["groups"].toList().cast<String>()))
      //           // .toList()
      //           // .cast<Account>(),
      //           entry["status"],
      //           entry["maxPeople"],
      //         ));
      //     mainData = preOrderData.toList().cast<PreOrder>();

      //     data = mainData!
      //         .where((element) => element.status != 'Completed')
      //         .toList();
      //     print('!****************************');
      //     print(data.length);
      //     print('!****************************');
      //   });
      // });
    });
  }

  var preOrderData;
  List<PreOrder>? mainData;
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
                  .map((v) => Item(v["foodId"], v["name"], v["description"],
                      v["count"], double.parse(v["price"])))
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
              entry["maxPeople"],
            ));
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

  @override
  void initState() {
    super.initState();
    getUserName();
    HelperFunction.saveUserLoggedInSP(true);
    HelperFunction.getUsernameSP().then((username) {
      Constant.myName = username.toString();
    });
    HelperFunction.getUserIDSP().then((userid) {
      Constant.myId = userid.toString();
    });
    HelperFunction.getEmailSP().then((email) {
      Constant.myEmail = email.toString();
    });

    print('!!!!!!!!!!!!!!!!!!!!!');
    print(uname);
    print('!!!!!!!!!!!!!!!!!!!!!');

    print('!!!!!!!!!!!!!!!!!!!!!');
    print(data);
    print('!!!!!!!!!!!!!!!!!!!!!');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: size.width,
      color: colorMainWhite,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            width: size.width,
            height: (246.0 * data.length),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailJoinPreOrder(
                                // data: widget.data,
                                ),
                          ),
                        );
                      },
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
