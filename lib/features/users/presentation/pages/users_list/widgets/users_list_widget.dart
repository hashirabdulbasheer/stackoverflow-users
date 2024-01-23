import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';

class SOFUsersListWidget extends StatelessWidget {
  final List<SOFUser> users;

  const SOFUsersListWidget({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('item ${users[index]}'),
        );
      },
    );
  }
}
