import 'package:kiolah/model/item.dart';

class UserItem {
  final String userId;
  final List<Item> items;

  UserItem({
    required this.userId,
    required this.items,
  });
}
