import 'package:kiolah/model/account.dart';

class Group {
  String groupId;
  String name;
  // String description;
  List<String> users;
  // String colorTheme;

  Group(
    this.groupId,
    this.name,
    this.users,
  );
}
