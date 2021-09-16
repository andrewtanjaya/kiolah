import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/UserItem.dart';

import 'form_item.dart';

class UserFormItem extends StatefulWidget {
  final List<UserItem>? userItems;
  final TextEditingController? userIdController;

  const UserFormItem({
    Key? key,
    this.userItems,
    this.userIdController,
  }) : super(key: key);

  @override
  _UserFormItemState createState() => _UserFormItemState();
}

class _UserFormItemState extends State<UserFormItem> {
  TextEditingController userIdController = new TextEditingController();
  List<UserItem> userItems = <UserItem>[];
  List<ItemForm> items = <ItemForm>[];

  var itemNameControllers = <TextEditingController>[];
  var itemDescriptionControllers = <TextEditingController>[];
  var itemPriceControllers = <TextEditingController>[];
  var itemQuantityControllers = <TextEditingController>[];

  void initState() {
    super.initState();
    userItems = widget.userItems!;
    // items.add(ItemForm());
  }

  String? userValidator(value) {}

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: 360,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorMainGray,
          width: 1.5,
        ),
        // color: Colors.blue,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.0),
            width: 320,
            child: TextInputContainer(
              child: TextInputField(
                controller: userIdController,
                validator: userValidator,
                icon: Icons.person_rounded,
                hintText: 'User',
                onChanged: (value) => {},
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            // color: Colors.green,
            width: size.width,
            height: (160.0 * items.length),
            // padding: EdgeInsets.symmetric(horizontal: 24.0),
            margin: EdgeInsets.all(0),
            child: Expanded(
              child: SizedBox(
                width: 360,
                height: (160.0 * items.length),
                child: ListView.separated(
                  // controller: _scrollController,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return items[index];
                  },
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0.0),
                ),
              ),
            ),
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => setState(() => items.add(createNewItem())),
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
        ],
      ),
    );
  }
}
