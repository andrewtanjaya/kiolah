import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/components/custom_dialog.dart';
import 'package:kiolah/components/round_button.dart';
import 'package:kiolah/components/text_input_container.dart';
import 'package:kiolah/components/text_input_field.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/model/account.dart';

class EditGroupDialog extends StatefulWidget {
  final dynamic group;
  const EditGroupDialog({Key? key, required this.group}) : super(key: key);

  @override
  _EditGroupDialogState createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  TextEditingController groupNameController = new TextEditingController();

  // yang deleted nanti ditarok disini
  late List<String> members;

  // dummy data
  List<String> usernames = ['ganteng', 'babet', 'cantik'];
  @override
  void initState() {
    super.initState();
    members = <String>[];
  }

  String? groupNameValidator(value) {
    if (value.toString().length <= 0) return 'Group\'s name must be filled';
    if (value.toString().trim().length > 15)
      return 'Group\'s name must only contains 15 characters';
  }

  // submit kelar
  submit() {
    if (formKey.currentState!.validate()) {
      var groupName = groupNameController.text.toString().trim();
      print(groupName);

      print(members);

      Navigator.pop(context);
      // showDialog(
      //   context: context,
      //   builder: (BuildContext dialogContext) {
      //     return CustomDialog(title: 'Groyu', description: description, imageUrl: imageUrl, textButton: textButton)();
      //   },
      // );
    }
  }

  final formKey = GlobalKey<FormState>();

  Widget memberItem({
    required String username,
    required String email,
    required String photoUrl,
    // required // List<dynamic>? userToken,
  }
      // bool? isAddedItem,
      ) {
    return Container(
      width: 200,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Container(
          //   width: 36.0,
          //   height: 36.0,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(36.0),
          //     image: DecorationImage(
          //       image: AssetImage(
          //         'assets/user/user.jpeg',
          //       ),
          //       alignment: Alignment.center,
          //       fit: BoxFit.fitWidth,
          //     ),
          //   ),
          // ),
          Container(
            width: 36.0,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.0),
            ),
            child: Image.network(
              photoUrl.toString(),
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          // RoundBorderedImage(
          //   imageUrl: photoUrl.toString(),
          //   colorBorder: colorMainWhite,
          //   size: 36.0,
          // ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: colorMainBlack,
                ),
              ),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                  color: colorMainGray,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          // if (isAddedItem != true)
          Container(
            width: 40.0,
            height: 40.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              // color: colorMainBlue,
              // boxShadow: [
              //   BoxShadow(
              //     color: colorMainBlue.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 7,
              //     offset: Offset(0, 2), // changes position of shadow
              //   ),
              // ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: colorError,
              ),
              onPressed: () {
                print(username);
                members.add(username);
                // function delete sini ya bos :)
                print('mantap jiwa');
                // members.add()

                // addMember(username);
              },
            ),
          ),
          // Container(
          //   width: 100,
          //   child: RoundButton(
          //     text: 'Add',
          //     onPressed: () {
          //       addMember(username);
          //     },
          //   ),
          // ),
          // Spacer(),
          // GestureDetector(
          //   onTap: () {
          //     print(userToken);
          //     sendNotif(userToken);
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     child: Text("Send"),
          //     decoration: BoxDecoration(
          //         color: Colors.yellow,
          //         borderRadius: BorderRadius.circular(15)),
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 320,
          height: 400,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Edit Group',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: colorMainBlack,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: TextInputContainer(
                        child: TextInputField(
                          controller: groupNameController,
                          validator: groupNameValidator,
                          maxLength: 15,
                          // icon: Icons.mail_outline_outlined,
                          hintText: 'Group Name',
                          onChanged: (value) => {},
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'MEMBERS',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: colorMainGray,
                        ),
                      ),
                    ),
                    Container(
                      width: 480,
                      child: Expanded(
                        child: SizedBox(
                          height: 140,
                          child: ListView.separated(
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return memberItem(
                                username: usernames[index],
                                email: 'adrian@gmail.com',
                                photoUrl:
                                    'https://www.pikpng.com/pngl/b/417-4172348_testimonial-user-icon-color-clipart.png',
                              );
                            },
                            // physics: NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 0.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: 160,
                  child: RoundButton(
                    text: 'Save',
                    onPressed: () {
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}