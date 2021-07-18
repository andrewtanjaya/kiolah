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

  updateUserPhoto(String photoUrl, String uname) {
    FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: uname)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({"photoUrl": photoUrl});
            }));
  }

  updateUserPhone(String phone, String uname) {
    FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: uname)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({"phoneNumber": phone});
            }));
  }

  updateUserPayment(List<String> pay, String uname) {
    FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: uname)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({"paymentType": pay});
            }));
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

  deleteChatRoom(String chatRoomId) async {
    deletePreorderbygroup(chatRoomId);
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .delete();
    });
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

  getPreorderGroup(String groupId) async {
    return await FirebaseFirestore.instance
        .collection("preorders")
        .where("group", isEqualTo: groupId)
        .get();
  }

  getListPreorder(String username) async {
    return await FirebaseFirestore.instance
        .collection("preorders")
        .where("users", arrayContains: username)
        .get();
  }

  getGroupById(String groupId) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(groupId)
        .get();
  }

  deletePreorderbygroup(String groupid) {
    FirebaseFirestore.instance
        .collection("preorders")
        .where("group", isEqualTo: groupid)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
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
