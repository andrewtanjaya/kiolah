import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/item.dart';

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

  uploadUserInfo(Map<String, dynamic> userMap, String userId) {
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
        .get();
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

  deleteToken(List<dynamic> token, String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({'token': FieldValue.arrayRemove(token)});
  }

  getListPreorder(String username) async {
    List<dynamic> sets = [
      {"username": username},
    ];
    return await FirebaseFirestore.instance
        .collection("preorders")
        .where("users", arrayContains: username)
        .get();
  }

  addPreorder(Map<String, dynamic> orderMap) async {
    String id = await FirebaseFirestore.instance
        .collection("preorders")
        .doc()
        .id
        .toString();
    orderMap["preOrderId"] = id;

    print(orderMap);
    FirebaseFirestore.instance.collection("preorders").doc(id).set(orderMap);
  }

  getAllPreorder() async {
    return await FirebaseFirestore.instance.collection("preorders").get();
  }

  getGroupById(String groupId) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(groupId)
        .get();
  }

  addPreorderitems(String preorderId, var items, String uname) {
    FirebaseFirestore.instance
        .collection("preorders")
        .doc(preorderId)
        .update({'items': FieldValue.arrayUnion(items)});
    FirebaseFirestore.instance.collection("preorders").doc(preorderId).update({
      'users': FieldValue.arrayUnion([uname])
    });
  }
}
