import 'package:kiolah/model/paymentType.dart';
import 'package:kiolah/model/group.dart';

class Account {
  String? userId;
  String? email;
  PaymentType? paymentType;
  String? phoneNumber;
  String? photoUrl;
  String? username;
  List<String>? groups;

  Account(
    this.userId,
    this.email,
    this.paymentType,
    this.phoneNumber,
    this.photoUrl,
    this.username,
    this.groups,
  );
}
