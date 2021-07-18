import 'account.dart';
import 'item.dart';

class PreOrder {
  String preOrderId;
  String title;
  String owner;
  String group;
  String location;
  List<Item> items;
  DateTime duration;
  List<String> users;
  String status;
  int maxPeople;

  PreOrder(this.preOrderId, this.title, this.owner, this.group, this.location,
      this.items, this.duration, this.users, this.status, this.maxPeople);
}
