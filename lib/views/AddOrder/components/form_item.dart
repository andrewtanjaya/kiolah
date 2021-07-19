import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';

class ItemForm extends StatelessWidget {
  final TextEditingController itemNameController;
  final TextEditingController itemDescriptionController;
  final TextEditingController itemQuantityController;
  final TextEditingController itemPriceController;

  const ItemForm({
    Key? key,
    required this.itemNameController,
    required this.itemDescriptionController,
    required this.itemQuantityController,
    required this.itemPriceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController itemNameController = new TextEditingController();
    // TextEditingController itemDescriptionController =
    //     new TextEditingController();
    // TextEditingController itemQuantityController = new TextEditingController();
    // TextEditingController itemPriceController = new TextEditingController();

    String? itemNameValidator(value) {
      return value.toString().length > 15 ? 'Name max 15 letter' : null;
    }

    String? itemDescriptionValidator(value) {
      return value.toString().length > 20 ? 'Description max 20 letter' : null;
    }

    String? itemQuantityValidator(value) {
      return int.parse(value.toString()) > 99 ? 'Quantity max 99 items' : null;
    }

    String? itemPriceValidator(value) {
      return int.parse(value.toString()) > 10000000
          ? 'Price max 10000000'
          : null;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          width: 1.5,
          color: colorMainGray,
        ),
        color: Colors.white30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            child: Column(
              children: [
                TextInputContainer(
                  child: TextInputField(
                    controller: itemNameController,
                    validator: itemNameValidator,
                    // icon: Icons.place_rounded,
                    maxLength: 15,
                    hintText: 'Name',
                    onChanged: (value) => {},
                  ),
                ),
                TextInputContainer(
                  child: TextInputField(
                    controller: itemDescriptionController,
                    validator: itemDescriptionValidator,
                    // icon: Icons.place_rounded,
                    maxLength: 20,
                    hintText: 'Description',
                    onChanged: (value) => {},
                  ),
                ),
                SizedBox(
                  height: 16.0,
                )
              ],
            ),
          ),
          Container(
            // color: Colors.blue,
            width: 120.0,
            child: Container(
              // color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputContainer(
                    child: TextInputField(
                      controller: itemPriceController,
                      validator: itemPriceValidator,
                      isNumberFormat: true,
                      maxLength: 8,
                      // icon: Icons.place_rounded,
                      hintText: 'Price',
                      onChanged: (value) => {},
                    ),
                  ),
                  Container(
                    width: 72.0,
                    child: TextInputContainer(
                      child: TextInputField(
                        controller: itemQuantityController,
                        validator: itemQuantityValidator,
                        isNumberFormat: true,
                        maxLength: 2,
                        // icon: Icons.place_rounded,
                        hintText: 'Qty',
                        onChanged: (value) => {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
