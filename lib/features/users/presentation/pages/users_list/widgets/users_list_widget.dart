import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../domain/entities/user.dart';
import 'users_list_item_widget.dart';

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
    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad
          },
        ),
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,
          onRefresh: () => Future.sync(
            () => pagingController.refresh(),
          ),
          child: PagedListView<int, SOFUser>.separated(
            separatorBuilder: (context, index) => const Divider(),
            pagingController: pagingController,
            physics: const AlwaysScrollableScrollPhysics(),
            builderDelegate: PagedChildBuilderDelegate<SOFUser>(
              itemBuilder: (context, item, index) => ListTile(
                title: SOFUsersListItemWidget(user: users[index]),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.star_border_rounded,
                    size: 40,
                    color: Colors.black54,
                  ),
                  onPressed: () => _onBookmarkTapped(users[index]),
                ),
              ),
            ),
          ),
        ));
  }

  void _onBookmarkTapped(SOFUser user) {}
}
