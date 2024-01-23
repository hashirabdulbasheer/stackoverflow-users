import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../features/users/presentation/pages/users_list_page.dart';

class SOFAppRoutes {
  static PageRoute getPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const SOFUsersListPage());

      case '/reputations':
        return MaterialPageRoute(builder: (_) => Container());

      case '/bookmarks':
        return MaterialPageRoute(builder: (_) => Container());

      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                      child: Text('error.page_not_found'.tr())),
                ));
    }
  }
}