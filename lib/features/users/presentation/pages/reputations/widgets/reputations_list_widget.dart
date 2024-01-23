import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../domain/entities/reputation.dart';
import 'reputations_list_item_widget.dart';

class SOFReputationsListWidget extends StatelessWidget {
  final PagingController<int, SOFReputation> pagingController;

  const SOFReputationsListWidget({
    Key? key,
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
          child: PagedListView<int, SOFReputation>.separated(
            separatorBuilder: (context, index) => const Divider(),
            pagingController: pagingController,
            physics: const AlwaysScrollableScrollPhysics(),
            builderDelegate: PagedChildBuilderDelegate<SOFReputation>(
              itemBuilder: (context, reputation, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    title: SOFReputationsListItemWidget(reputation: reputation),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
