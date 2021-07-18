import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/preorder_card.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/model/preOrder.dart';
import 'package:kiolah/services/database.dart';
import './components/body.dart';

class ExplorePage extends StatefulWidget {
  final ScrollController scrollController;
  ExplorePage({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        backgroundColor: colorMainWhite,
        elevation: 0,
        title: Text(
          'Explore',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: colorMainBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Body(),
      ),
    );
  }
}
