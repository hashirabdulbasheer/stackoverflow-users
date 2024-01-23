import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';

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
                  title: Text(users[index].name),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: users.length),
        ));
  }
}
