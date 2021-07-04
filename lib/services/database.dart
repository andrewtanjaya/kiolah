import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(Map<String, String> userMap, String userId) {
    FirebaseFirestore.instance.collection("users").doc(userId).set(userMap);
  }

  addChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: username)
        .snapshots();
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap);
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("timestamp")
        .snapshots();
  }

  addToken(String? token, String userId) {
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      'token': FieldValue.arrayUnion([token])
    });
  }
}
