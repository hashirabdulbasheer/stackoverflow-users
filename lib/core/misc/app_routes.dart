import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/users/domain/usecases/fetch_users_usecase.dart';
import '../../features/users/presentation/bloc/users/users.dart';
import '../../features/users/presentation/pages/users_list/users_list_page.dart';
import 'di_container.dart';

class SOFAppRoutes {
  static PageRoute getPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SOFUsersListPageBloc>(
                        create: (BuildContext context) => SOFUsersListPageBloc(
                            fetchUsersUseCase: sl<SOFFetchUsersUseCase>())
                          ..add(SOFUsersListPageLoadEvent(page: 1)))
                  ],
                  child: const SOFUsersListPage(),
                ));

      case '/reputations':
        return MaterialPageRoute(builder: (_) => Container());

      case '/bookmarks':
        return MaterialPageRoute(builder: (_) => Container());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('error.page_not_found'.tr())),
                ));
    }
  }
}
