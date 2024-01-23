import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/users/domain/usecases/delete_bookmarks_usecase.dart';
import '../../features/users/domain/usecases/fetch_bookmarks_usecase.dart';
import '../../features/users/domain/usecases/fetch_reputations_usecase.dart';
import '../../features/users/domain/usecases/fetch_users_usecase.dart';
import '../../features/users/domain/usecases/save_bookmarks_usecase.dart';
import '../../features/users/presentation/bloc/bookmarks/bookmarks.dart';
import '../../features/users/presentation/bloc/reputations/reputations.dart';
import '../../features/users/presentation/bloc/users/users.dart';
import '../../features/users/presentation/pages/bookmarks/bookmarks_list_page.dart';
import '../../features/users/presentation/pages/reputations/reputations_list_page.dart';
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
                              fetchUsersUseCase: sl<SOFFetchUsersUseCase>(),
                              saveBookmarksUseCase:
                                  sl<SOFSaveBookmarksUseCase>(),
                              deleteBookmarksUseCase:
                                  sl<SOFDeleteBookmarksUseCase>(),
                            )..add(SOFInitializeUserListPageEvent()))
                  ],
                  child: const SOFUsersListPage(),
                ));

      case '/reputations':
        int userId = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SOFReputationsListPageBloc>(
                        create: (BuildContext context) =>
                            SOFReputationsListPageBloc(
                                fetchReputationsUseCase:
                                    sl<SOFFetchReputationsUseCase>())
                              ..add(SOFInitializeReputationsListPageEvent(
                                  userId: userId)))
                  ],
                  child: SOFReputationsListPage(
                    userId: userId,
                  ),
                ));

      case '/bookmarks':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SOFBookmarksListPageBloc>(
                        create: (BuildContext context) =>
                            SOFBookmarksListPageBloc(
                                fetchBookmarksUseCase:
                                    sl<SOFFetchBookmarksUseCase>(),
                                deleteBookmarksUseCase:
                                    sl<SOFDeleteBookmarksUseCase>())
                              ..add(SOFLoadBookmarksListPageEvent()))
                  ],
                  child: const SOFBookmarksListPage(),
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('error.page_not_found'.tr())),
                ));
    }
  }
}
