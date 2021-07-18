import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiolah/etc/constants.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/services/database.dart';
import 'package:kiolah/views/chatList.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen({required this.chatRoomId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream<QuerySnapshot>? chatMessageStream;
  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageItem(
                      message: snapshot.data!.docs[index]["message"],
                      isSendByMe: snapshot.data!.docs[index]["sendBy"] ==
                          Constant.myName,
                    );
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text != "") {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constant.myName,
        "timestamp": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversation",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorMainWhite,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Send Message",
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: colorMainBlue,
                            borderRadius: BorderRadius.circular(46)),
                        width: 46,
                        height: 46,
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.send_rounded,
                          color: colorMainWhite,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageItem({required this.message, required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 10, right: isSendByMe ? 10 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            color: isSendByMe ? colorMainBlue : Colors.grey,
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: Text(
          message,
          style: GoogleFonts.poppins(
            backgroundColor: isSendByMe ? colorMainBlue : colorMainGray,
            color: isSendByMe ? colorMainWhite : colorMainBlue,
            // color: isSendByMe ? colorMainGray : Colors.white,
          ),
        ),
      ),
    );
  }
}
