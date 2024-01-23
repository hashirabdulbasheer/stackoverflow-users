import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../domain/entities/user.dart';

class SOFUsersListWidget extends StatelessWidget {
  final List<SOFUser> users;
  final PagingController<int, SOFUser> pagingController;

  const SOFUsersListWidget({
    Key? key,
    required this.users,
    required this.pagingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, SOFUser>.separated(
      separatorBuilder: (context, index) => const Divider(),
      pagingController: pagingController,
      physics: const AlwaysScrollableScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<SOFUser>(
        itemBuilder: (context, item, index) => ListTile(
          title: Text('item ${users[index].name}'),
        ),
      ),
    );
  }
}
