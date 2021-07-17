import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/item.dart';

import 'components/form_item.dart';
import 'components/user_form_item.dart';

class AddOrder extends StatefulWidget {
  // final ScrollController scrollController;
  AddOrder({
    Key? key,
    // required this.scrollController,
  }) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  List<UserFormItem> userItems = <UserFormItem>[];
  List<ItemForm> itemForms = <ItemForm>[];
  // controller
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController groupController = new TextEditingController();
  TextEditingController maxPeopleController = new TextEditingController();

  var userIds = <TextEditingController>[];
  var itemNames = <TextEditingController>[];
  var descriptions = <TextEditingController>[];
  var prices = <TextEditingController>[];
  var quantities = <TextEditingController>[];

  String? titleValidator(value) {
    if (value.toString().length <= 0) {
      return 'Preorder name must be filled';
    } else {
      return value.toString().length > 10 ? 'Title max 10 letter' : null;
    }
  }

  String? locationValidator(value) {
    if (value.toString().length <= 0) {
      return 'Location must be filled';
    } else {
      return value.toString().length > 20 ? 'Location max 20 letter' : null;
    }
  }

  String? groupValidator(value) {
    if (value.toString().length <= 0) {
      return 'Group must be filled';
    }
  }

  String? maxPeopleValidator(value) {
    return int.parse(value.toString()) <= 0
        ? 'Max People must be more than 0'
        : null;
  }

  void initState() {
    super.initState();
    itemForms.add(createNewItem());
  }

  createPreOrder() {
    if (formKey.currentState!.validate()) {
      var title = titleController.value.toString().trim();
      var location = locationController.value.toString().trim();
      var group = groupController.value.toString().trim();
      var maxPeople = int.parse(maxPeopleController.value.toString().trim());
      // List<Item> items = [];
      // // List<String> names = [];
      // // List<String> names = [];
      // for (int i = 0; i < itemForms.length; i++) {
      //   var name = itemNameControllers[i].text;
      //   var desc = itemDescriptionControllers[i].text;
      //   var quantity = itemQuantityControllers[i].text;
      //   var price = itemPriceControllers[i].text;
      //   // var age = ageTECs[i].text;
      //   // var job = jobTECs[i].text;
      //   items.add(Item(i.toString(), name, desc, int.parse(quantity),
      //       double.parse(price)));
      //   // entries.add(PersonEntry(name, age, job));
      // }

      // for (int i = 0; i < items.length; i++) {
      //   // var name = itemNameControllers[i].text;
      //   // var desc = itemDescriptionControllers[i].text;
      //   // var quantity = itemQuantityControllers[i].text;
      //   // var price = itemPriceControllers[i].text;
      //   // // var age = ageTECs[i].text;
      //   // var job = jobTECs[i].text;
      //   // items.add(Item(i.toString(), name, desc, int.parse(quantity),
      //   //     double.parse(price)));
      //   // entries.add(PersonEntry(name, age, job));
      //   print(
      //       'id : ${items[i].foodId}; name : ${items[i].name}; description : ${items[i].description}; count : ${items[i].count}; price : ${items[i].price}');
    }

    // Navigator.pop(context, entries);
  }

  createNewItem() {
    var itemNameController = TextEditingController();
    var itemDescriptionController = TextEditingController();
    var itemPriceController = TextEditingController();
    var itemQuantityController = TextEditingController();
    itemNameControllers.add(itemNameController);
    itemDescriptionControllers.add(itemDescriptionController);
    itemPriceControllers.add(itemPriceController);
    itemQuantityControllers.add(itemQuantityController);
    return ItemForm(
      itemDescriptionController: itemDescriptionController,
      itemNameController: itemNameController,
      itemPriceController: itemPriceController,
      itemQuantityController: itemQuantityController,
    );
  }

  createUserItem() {
    return UserFormItem();
  }

  var itemNameControllers = <TextEditingController>[];
  var itemDescriptionControllers = <TextEditingController>[];
  var itemPriceControllers = <TextEditingController>[];
  var itemQuantityControllers = <TextEditingController>[];

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
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          color: colorMainWhite,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
          // alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        'Create',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: colorMainBlack,
                        ),
                      ),
                    ),
                    FittedBox(
                      // width: ,
                      // color: Colors.pink,
                      child: Text(
                        'New Preorder',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: colorMainBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputContainer(
                        child: TextInputField(
                          controller: titleController,
                          validator: titleValidator,
                          hintText: 'Preorder name',
                          onChanged: (value) => {},
                        ),
                      ),
                      TextInputContainer(
                        child: TextInputField(
                          controller: locationController,
                          validator: locationValidator,
                          icon: Icons.place_rounded,
                          hintText: 'Location',
                          onChanged: (value) => {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        child: TextInputContainer(
                          child: TextInputField(
                            controller: groupController,
                            validator: groupValidator,
                            icon: Icons.group_rounded,
                            hintText: 'Group',
                            onChanged: (value) => {},
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //       vertical: 8.0, horizontal: 16.0),
                      //   // color: Colors.pink,
                      //   child: Text(
                      //     'ITEMS',
                      //     style: GoogleFonts.poppins(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 14.0,
                      //       color: colorMainGray,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   // color: Colors.green,
                      //   width: 360,
                      //   height: (290.0 * itemForms.length),
                      //   // padding: EdgeInsets.symmetric(horizontal: 24.0),
                      //   margin: EdgeInsets.all(0),
                      //   child: Expanded(
                      //     child: SizedBox(
                      //       width: 360,
                      //       height: (290.0 * itemForms.length),
                      //       child: ListView.separated(
                      //         // controller: _scrollController,
                      //         itemCount: itemForms.length,
                      //         itemBuilder: (BuildContext context, int index) {
                      //           return itemForms[index];
                      //         },
                      //         physics: NeverScrollableScrollPhysics(),
                      //         separatorBuilder:
                      //             (BuildContext context, int index) =>
                      //                 const SizedBox(height: 24.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        child: TextInputContainer(
                          child: TextInputField(
                            controller: maxPeopleController,
                            validator: maxPeopleValidator,
                            icon: Icons.group_rounded,
                            hintText: 'Max People',
                            isNumberFormat: true,
                            onChanged: (value) => {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: size.width,
              //   // color: Colors.green,
              //   alignment: Alignment.center,
              //   // margin: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: TextButton(
              //     onPressed: () =>
              //         setState(() => itemForms.add(createNewItem())),
              //     child: Text(
              //       'ADD NEW USER',
              //       style: GoogleFonts.poppins(
              //         fontWeight: FontWeight.w600,
              //         color: colorMainGray,
              //         fontSize: 14.0,
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: RoundButton(
                  text: 'CREATE',
                  onPressed: () {
                    // createPreOrder();
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