import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/preOrder.dart';
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
  List<PreOrder> mainData = [
    PreOrder(
      '1',
      'Makan bareng',
      'Adrian',
      '1',
      'Rocky Roosters',
      [
        Item('1', 'Ayam goreng kalasan', 'no desc', 2, 123000),
        Item('2', 'Teh Manis dingin', 'no desc', 4, 5000),
        Item('3', 'Nasi putih', 'no desc', 2, 6000),
      ],
      DateTime.now().subtract(new Duration(minutes: 15)),
      [
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'adrian',
            userId: '6',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'ryujin',
            userId: '7',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'winter',
            userId: '8',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'karina',
            userId: '9',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'jisoo',
            userId: '10',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
      ],
      'Ongoing',
    ),
    PreOrder(
      '2',
      'Makan bareng mantan',
      'Unknown',
      '2',
      'Warteg Kharisma',
      [
        Item('1', 'Nasi campur sultan', 'tidak sambal', 2, 15000),
      ],
      DateTime.now().subtract(new Duration(hours: 2)),
      [
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'mantan',
            userId: '3',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'hen suai',
            userId: '4',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
      ],
      'Unpaid',
    ),
    PreOrder(
      '3',
      'Friendzoned',
      'Stephanie',
      '3',
      'Bel Mondo',
      [
        Item('1', 'Nasi goreng spesial', 'tidak micin', 2, 32000),
        Item('2', 'Jus stroberi', 'no ice', 2, 16000),
      ],
      DateTime.now().subtract(new Duration(seconds: 30)),
      [
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'ganteng',
            userId: '1',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'jisoo',
            userId: '2',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
      ],
      'Completed',
    ),
    PreOrder(
      '4',
      'Mantap',
      'Josephine',
      '1',
      'Hai Di Lao',
      [
        Item('1', 'Nasi goreng spesial', 'tidak micin', 2, 32000),
        Item('2', 'Jus stroberi', 'no ice', 1, 16000),
        Item('3', 'Sup ayam', 'no desc', 3, 48000),
        Item('4', 'Truffle ayam', 'no desc', 4, 32000),
      ],
      DateTime.now().subtract(new Duration(seconds: 30)),
      [
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'ganteng',
            userId: '1',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'jisoo',
            userId: '2',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
      ],
      'Completed',
    ),
    PreOrder(
      '4',
      'Mantap',
      'Jisoo',
      '1',
      'Hai Di Lao',
      [
        Item('1', 'Nasi goreng spesial', 'tidak micin', 2, 32000),
        Item('2', 'Jus stroberi', 'no ice', 1, 16000),
        Item('3', 'Sup ayam', 'no desc', 3, 48000),
        Item('4', 'Truffle ayam', 'no desc', 4, 32000),
        Item('5', 'Sup Buah', 'no desc', 1, 40000),
        Item('6', 'Mie goreng udang', 'no desc', 2, 50000),
      ],
      DateTime.now().subtract(new Duration(seconds: 30)),
      [
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'ganteng',
            userId: '1',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
        Account(
            photoUrl: 'assets/user/user.jpeg',
            username: 'jisoo',
            userId: '2',
            paymentType: PaymentType(39385085261852895, 1950429854),
            phoneNumber: '9123912039012'),
      ],
      'Unpaid',
    ),
  ];
  List<PreOrder> data = <PreOrder>[];
  List<Group> groups = [
    Group(
      '1',
      'ganteng ganteng club',
      'para cogan',
      [
        '1',
        '2',
        '3',
      ],
      '0xFFEDB95E',
    ),
    Group(
      '2',
      'cantik cantik club',
      'para cantik girl',
      [
        '3',
        '4',
        '5',
      ],
      '0xFFED2C5B',
    ),
    Group(
      '3',
      'sultan club',
      'para sultan',
      [
        '1',
        '2',
        '3',
      ],
      '0xFF4EDBB0',
    ),
  ];

  // informasi header
  var username = 'Adrian !';
  var totalPreorder = 3;
  var imageUrl = 'assets/user/2.png';

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController;
    data = mainData.where((element) => element.status != 'Completed').toList();
    // widget.scrollController = ScrollController();
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
        data =
            mainData.where((element) => element.status != 'Completed').toList();
      if (index == 1)
        data =
            mainData.where((element) => element.status == 'Completed').toList();
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: ListView.separated(
                  // controller: _scrollController,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 12.0,
                      height: 48.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: colorWarning,
                      ),
                      child: Text(
                        'W',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: colorMainWhite,
                          fontSize: 12.0,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16.0),
                  // physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: colorMainWhite,
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              // header
              Header(
                username: username,
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
                // color: Colors.green,
                child: Expanded(
                  child: SizedBox(
                    width: 350,
                    height: size.height - 320,
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PreorderCard(
                          data: data[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 16.0),
                      // physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
