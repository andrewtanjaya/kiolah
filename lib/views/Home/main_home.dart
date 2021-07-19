import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/fab.dart';
import 'package:kiolah/components/fab_extended.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/AddOrder/addOrder.dart';
import 'package:kiolah/views/GroupPage/groupPage.dart';
import '../search.dart';
import 'components/body.dart';
import 'components/header.dart';

class MainHome extends StatefulWidget {
  final ScrollController scrollController;
  MainHome({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  DatabaseMethods db = new DatabaseMethods();
  var uname;
  var preOrderData;
  var groups;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
      DatabaseMethods().getChatRooms(uname).then((val) {
        setState(() {
          groups = val.docs;
        });
      });
      getAllData();
    });
  }

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
                  .map((v) => Item(
                      v["foodId"].toString(),
                      v["name"],
                      v["description"],
                      v["count"],
                      double.parse(v["price"].toString()).toDouble(),
                      v["username"]))
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
        // print('!****************************');
        // print(data.length);
        // print('!****************************');
      });
    });
  }

  // PreOrder(
  //   '1',
  //   'Makan bareng',
  //   'Adrian',
  //   '1',
  //   'Rocky Roosters',
  //   [
  //     Item('1', 'Ayam goreng kalasan', 'no desc', 2, 123000),
  //     Item('2', 'Teh Manis dingin', 'no desc', 4, 5000),
  //     Item('3', 'Nasi putih', 'no desc', 2, 6000),
  //   ],
  //   DateTime.now().subtract(new Duration(minutes: 15)),
  //   [
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'adrian',
  //         userId: '6',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'ryujin',
  //         userId: '7',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'winter',
  //         userId: '8',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'karina',
  //         userId: '9',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'jisoo',
  //         userId: '10',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //   ],
  //   'Ongoing',
  // ),
  // PreOrder(
  //   '2',
  //   'Makan bareng mantan',
  //   'Unknown',
  //   '2',
  //   'Warteg Kharisma',
  //   [
  //     Item('1', 'Nasi campur sultan', 'tidak sambal', 2, 15000),
  //   ],
  //   DateTime.now().subtract(new Duration(hours: 2)),
  //   [
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'mantan',
  //         userId: '3',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'hen suai',
  //         userId: '4',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //   ],
  //   'Unpaid',
  // ),
  // PreOrder(
  //   '3',
  //   'Friendzoned',
  //   'Stephanie',
  //   '3',
  //   'Bel Mondo',
  //   [
  //     Item('1', 'Nasi goreng spesial', 'tidak micin', 2, 32000),
  //     Item('2', 'Jus stroberi', 'no ice', 2, 16000),
  //   ],
  //   DateTime.now().subtract(new Duration(seconds: 30)),
  //   [
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'ganteng',
  //         userId: '1',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'jisoo',
  //         userId: '2',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //   ],
  //   'Completed',
  // ),
  // PreOrder(
  //   '4',
  //   'Mantap',
  //   'Josephine',
  //   '1',
  //   'Hai Di Lao',
  //   [
  //     Item('1', 'Nasi goreng spesial', 'tidak micin', 2, 32000),
  //     Item('2', 'Jus stroberi', 'no ice', 1, 16000),
  //     Item('3', 'Sup ayam', 'no desc', 3, 48000),
  //     Item('4', 'Truffle ayam', 'no desc', 4, 32000),
  //   ],
  //   DateTime.now().subtract(new Duration(seconds: 30)),
  //   [
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'ganteng',
  //         userId: '1',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'jisoo',
  //         userId: '2',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //   ],
  //   'Completed',
  // ),
  // PreOrder(
  //   '4',
  //   'Mantap',
  //   'Jisoo',
  //   '1',
  //   'Hai Di Lao',
  //   [
  //     Item('1', 'Nasi goreng spesial', 'tidak micin', 2, 32000),
  //     Item('2', 'Jus stroberi', 'no ice', 1, 16000),
  //     Item('3', 'Sup ayam', 'no desc', 3, 48000),
  //     Item('4', 'Truffle ayam', 'no desc', 4, 32000),
  //     Item('5', 'Sup Buah', 'no desc', 1, 40000),
  //     Item('6', 'Mie goreng udang', 'no desc', 2, 50000),
  //   ],
  //   DateTime.now().subtract(new Duration(seconds: 30)),
  //   [
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'ganteng',
  //         userId: '1',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //     Account(
  //         photoUrl: 'assets/user/user.jpeg',
  //         username: 'jisoo',
  //         userId: '2',
  //         paymentType: PaymentType(39385085261852895, 1950429854),
  //         phoneNumber: '9123912039012'),
  //   ],
  //   'Unpaid',
  // ),

  List<PreOrder> data = <PreOrder>[];
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

  // informasi header

  var totalPreorder = 3;
  var imageUrl = '';

  // informasi header
  late ScrollController _scrollController;

  var isFAB = false;
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

    // data = mainData!.where((element) => element.status != 'Completed').toList();
    // widget.scrollController = ScrollController();
    _scrollController = widget.scrollController;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.addListener(() {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            setState(() {
              isFAB = true;
            });
          } else {
            setState(() {
              isFAB = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

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

  showAddOrderPage() {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => AddOrder()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        title: Text(
          'Kiolah',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: colorMainBlack,
          ),
        ),
        elevation: 0,
        backgroundColor: colorMainWhite,
        iconTheme: IconThemeData(
          color: colorMainBlack,
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: colorMainBlack,
        ),
        child: Container(
          width: 80,
          child: Drawer(
            elevation: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Expanded(
                      child: SizedBox(
                        height: (groups?.length ?? 0) * 76.0,
                        child: ListView.separated(
                          // controller: _scrollController,
                          itemCount: (groups?.length ?? 0),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GroupPage(group: groups[index])));
                              },
                              child: Container(
                                width: 12.0,
                                height: 48.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: colorMainWhite,
                                ),
                                child: Text(
                                  groups[index]["groupName"][0]
                                      .toString()
                                      .toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: colorMainGray,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            );
                          },
                          physics: new NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 12.0),
                          // physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 48.0,
                    height: 48.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48.0),
                      color: colorMainGray,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Body(
            // scrollController: _scrollController,
            ),
      ),
      floatingActionButton: isFAB
          ? FAB(icon: Icons.edit_rounded, onPressed: () {})
          : FABExtended(
              text: 'Add Preorder',
              onPressed: () {},
              icon: Icons.edit_rounded,
            ),
    );
  }
}
