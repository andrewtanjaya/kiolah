import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/fab.dart';
import 'package:kiolah/components/fab_extended.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/etc/generate_color.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/group.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/views/AddOrder/addOrder.dart';
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
  // informasi header
  late ScrollController _scrollController;

  var isFAB = false;
  @override
  void initState() {
    super.initState();
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

  showAddOrderPage() {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => AddOrder()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                controller: _scrollController,
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Body(
          scrollController: _scrollController,
        ),
      ),
      floatingActionButton: isFAB
          ? FAB(icon: Icons.edit_rounded, onPressed: () {})
          : FABExtended(
              text: 'Add preorder',
              onPressed: () {},
              icon: Icons.edit_rounded,
            ),
    );
  }
}
