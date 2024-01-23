import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/user.dart';
import '../../../bloc/bookmarks/bookmarks.dart';
import '../../users_list/widgets/users_list_item_widget.dart';

class SOFBookmarksListWidget extends StatelessWidget {
  final List<SOFUser> users;
  final Function onRefresh;

  const SOFBookmarksListWidget({
    Key? key,
    required this.users,
    required this.onRefresh,
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
          onRefresh: () => Future.sync(() => onRefresh()),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: SOFUsersListItemWidget(user: users[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,
                        size: 40, color: Colors.black54),
                    onPressed: () => _onDeleteTapped(context, users[index]),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: users.length),
        ));
  }

  void _onDeleteTapped(BuildContext context, SOFUser user) {
    SOFBookmarksListPageBloc bloc = context.read<SOFBookmarksListPageBloc>();
    bloc.add(SOFDeleteBookmarkListPageEvent(user: user));
  }
}
