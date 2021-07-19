import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiolah/helper/constant.dart';
import 'package:kiolah/helper/helperFunction.dart';
import 'package:kiolah/model/account.dart';
import 'package:kiolah/model/item.dart';
import 'package:kiolah/views/Home/home.dart';

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

  addChatRoomUpdate(var context, String before, String chatRoomId, chatRoomMap,
      List<dynamic> messages) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .then((value) {
      messages.forEach((element) {
        FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(chatRoomId)
            .collection("chats")
            .add(element);
      });
      updatePreorderGroup(context, chatRoomId, before);
    });
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: username)
        .get();
  }

  getChatRoomsbyId(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .get();
  }

  checkChatRoomID(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .get();
  }

  updateChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
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

  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("timestamp")
        .get();
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

  updatePreorder(String title, int maxPeople, String preorderId) async {
    await FirebaseFirestore.instance
        .collection("preorders")
        .where("preOrderId", isEqualTo: preorderId)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({"title": title});
              documentSnapshot.reference.update({"maxPeople": maxPeople});
            }));
  }

  updatePreorderItem(
      String username, String preorderId, dynamic item, bool noMoreItem) {
    Map<String, dynamic> itemMap = {
      "count": item.count,
      "description": item.description,
      "foodId": item.foodId,
      "name": item.name,
      "price": item.price,
      "username": item.username
    };
    FirebaseFirestore.instance
        .collection("preorders")
        .where("preOrderId", isEqualTo: preorderId)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({
                'items': FieldValue.arrayRemove([itemMap])
              });

              if (noMoreItem == true) {
                documentSnapshot.reference.update({
                  'users': FieldValue.arrayRemove([username])
                });
              }
            }));
  }

  updatePreorderGroup(var context, String groupId, String old) {
    FirebaseFirestore.instance
        .collection("preorders")
        .where("group", isEqualTo: old)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        print("SINI COK");
        documentSnapshot.reference.update({"group": groupId});
      });
      deleteChatRoom(old);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  updatePreorderStatus(String status, String preorderId) {
    FirebaseFirestore.instance
        .collection("preorders")
        .where("preOrderId", isEqualTo: preorderId)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({"status": status});
            }));
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
    addTransaction(uname, preorderId);
  }

  addTransaction(String username, String preorderId) {
    FirebaseFirestore.instance.collection("transactions").add(
        {"username": username, "preOrderId": preorderId, "status": "Unpaid"});
  }

  setTransaction(String username, String preorderId, String status) async {
    FirebaseFirestore.instance
        .collection("transactions")
        .where("preOrderId", isEqualTo: preorderId)
        .where("username", isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((documentSnapshot) {
              documentSnapshot.reference.update({
                "username": username,
                "preOrderId": preorderId,
                "status": status
              });
            }));
  }

  getUnpaidTransaction(String username) {
    return FirebaseFirestore.instance
        .collection("transactions")
        .where("username", isEqualTo: username)
        .where("status", isEqualTo: "Unpaid")
        .get();
  }

  getStatusTransaction(String username, String preorderId) {
    return FirebaseFirestore.instance
        .collection("transactions")
        .where("username", isEqualTo: username)
        .where("preOrderId", isEqualTo: preorderId)
        .get();
  }

  getPreorder(String preorderid) async {
    return await FirebaseFirestore.instance
        .collection("preorders")
        .doc(preorderid)
        .get();
  }
}
