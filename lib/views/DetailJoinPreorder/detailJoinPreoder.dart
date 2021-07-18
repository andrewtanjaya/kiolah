import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/add_header.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/views/AddOrder/components/form_item.dart';

class DetailJoinPreOrder extends StatefulWidget {
  DetailJoinPreOrder({Key? key}) : super(key: key);

  @override
  _DetailJoinPreOrderState createState() => _DetailJoinPreOrderState();
}

class _DetailJoinPreOrderState extends State<DetailJoinPreOrder> {
  var itemForms = <ItemForm>[];
  var uname;

  getUserName() async {
    await HelperFunction.getUsernameSP().then((username) {
      uname = username.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    itemForms.add(createNewItem());
    getUserName();
  }

  addPreorderItem() {
    List<Item> items = [];
    List<String> names = [];
    print(itemNameControllers[0].text);
    for (int i = 0; i < itemForms.length; i++) {
      var name = itemNameControllers[i].text;
      var desc = itemDescriptionControllers[i].text;
      var quantity = itemQuantityControllers[i].text;
      var price = itemPriceControllers[i].text;
      items.add(Item(i.toString(), name, desc, int.parse(quantity),
          double.parse(price), uname));
    }

    // items --> collection dari object item jadi tinggal upload dari situ :)
    for (int i = 0; i < items.length; i++) {
      print(
          'id : ${items[i].foodId}; name : ${items[i].name}; description : ${items[i].description}; count : ${items[i].count}; price : ${items[i].price}');
    }
  }

  final formKey = GlobalKey<FormState>();
  var itemNameControllers = <TextEditingController>[];
  var itemDescriptionControllers = <TextEditingController>[];
  var itemPriceControllers = <TextEditingController>[];
  var itemQuantityControllers = <TextEditingController>[];

  createNewItem() {
    var itemNameController = new TextEditingController();
    var itemDescriptionController = new TextEditingController();
    var itemPriceController = new TextEditingController();
    var itemQuantityController = new TextEditingController();
    itemNameControllers.add(itemNameController);
    itemDescriptionControllers.add(itemDescriptionController);
    itemPriceControllers.add(itemPriceController);
    itemQuantityControllers.add(itemQuantityController);
    return new ItemForm(
      itemDescriptionController: itemDescriptionController,
      itemNameController: itemNameController,
      itemPriceController: itemPriceController,
      itemQuantityController: itemQuantityController,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorMainWhite,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colorMainBlack,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: colorMainWhite,
          width: size.width,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddHeader(firstText: 'Add', secondText: 'Preoder\'s Item'),
              Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        // color: Colors.pink,
                        child: Text(
                          'ITEMS',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: colorMainGray,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        // color: Colors.green,
                        width: 360,
                        height: (180.0 * itemForms.length),
                        // padding: EdgeInsets.symmetric(horizontal: 24.0),
                        margin: EdgeInsets.all(0),
                        child: Expanded(
                          child: SizedBox(
                            width: 360,
                            height: (180.0 * itemForms.length),
                            child: ListView.separated(
                              // controller: _scrollController,
                              itemCount: itemForms.length,
                              itemBuilder: (BuildContext context, int index) {
                                return itemForms[index];
                              },
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 24.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: size.width,
                // color: Colors.green,
                alignment: Alignment.center,
                // margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: () =>
                      setState(() => itemForms.add(createNewItem())),
                  child: Text(
                    'ADD NEW ITEM',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: colorMainGray,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: RoundButton(
                  text: 'ADD ITEMS',
                  onPressed: () {
                    addPreorderItem();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
