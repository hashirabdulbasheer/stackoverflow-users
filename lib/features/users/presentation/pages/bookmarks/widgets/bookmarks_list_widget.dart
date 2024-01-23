import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';

class SOFBookmarksListWidget extends StatelessWidget {
  final List<SOFUser> users;

  const SOFBookmarksListWidget({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].name),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: users.length);
  }
}
