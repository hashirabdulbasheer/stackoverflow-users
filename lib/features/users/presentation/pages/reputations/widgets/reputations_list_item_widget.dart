import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/reputation.dart';

class SOFReputationsListItemWidget extends StatelessWidget {
  final SOFReputation reputation;

  const SOFReputationsListItemWidget({Key? key, required this.reputation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${"reputation.type".tr()}: ${reputation.type}'),
        Text('${"reputation.change".tr()}: ${reputation.change}'),
        Text('${"reputation.created_at".tr()}: ${reputation.createdAt}'),
        Text('${"reputation.post_id".tr()}: ${reputation.postId}'),
      ],
    );
  }
}
