import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/core/db/hive_manager.dart';
import 'package:stackoverflow_users/features/users/data/datasources/network/users_network_datasource.dart';
import 'package:stackoverflow_users/features/users/data/repositories/bookmarks_repository_impl.dart';
import 'package:stackoverflow_users/features/users/domain/entities/user.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/bookmarks_repository.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/delete_bookmarks_usecase.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/fetch_users_usecase.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/save_bookmarks_usecase.dart';
import 'package:stackoverflow_users/features/users/presentation/bloc/users/users.dart';

import '../../../../../utils/test_utils.dart';
import '../../../domain/repositories/user_repository_test.dart';

void main() {
  SOFBookmarksRepository makeBookmarksRepository(http.Client client) {
    SOFUsersNetworkDataSource networkDataSource =
        SOFUsersNetworkDataSourceImpl(client: client);
    SOFUsersBookmarkDataSource bookmarksDataSource = MockBookmarksDataSource();
    return SOFBookmarksRepositoryImpl(
        networkDataSource: networkDataSource,
        bookmarkDataSource: bookmarksDataSource);
  }

  SOFUsersListPageBloc makeBloc() {
    http.Client client = TestUtils.makeUsersClient(
        response: http.Response(TestUtils.singleUserJson, 201));
    SOFFetchUsersUseCase fetchUsersUseCase =
        SOFFetchUsersUseCase(repository: makeRepository(client));
    SOFSaveBookmarksUseCase saveBookmarksUseCase =
        SOFSaveBookmarksUseCase(repository: makeBookmarksRepository(client));
    SOFDeleteBookmarksUseCase deleteBookmarksUseCase =
        SOFDeleteBookmarksUseCase(repository: makeBookmarksRepository(client));

    return SOFUsersListPageBloc(
        fetchUsersUseCase: fetchUsersUseCase,
        saveBookmarksUseCase: saveBookmarksUseCase,
        deleteBookmarksUseCase: deleteBookmarksUseCase);
  }

  SOFUser user = const SOFUser(
      id: 22656,
      name: "JonSkeet",
      avatar:
          "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG",
      location: "Reading,UnitedKingdom",
      age: null,
      reputation: 1444575,
      isBookmarked: false);

  group("user bloc tests", () {
    blocTest<SOFUsersListPageBloc, SOFUsersListPageState>(
      'Initialization event loads users',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
      },
      expect: () => <SOFUsersListPageState>[
        SOFUsersListPageLoadingState(),
        SOFUsersListPageLoadedState(users: [user], page: 1, isLoading: false),
      ],
    );

    blocTest<SOFUsersListPageBloc, SOFUsersListPageState>(
      'Page load event loads same user if duplicate',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
        bloc.add(SOFUsersListPageLoadEvent(page: 1));
      },
      expect: () => <SOFUsersListPageState>[
        SOFUsersListPageLoadingState(),
        SOFUsersListPageLoadedState(users: [user], page: 1, isLoading: false),
        SOFUsersListPageLoadedState(users: [user], page: 1, isLoading: true),
        SOFUsersListPageLoadedState(users: [user], page: 1, isLoading: false),
      ],
    );
  });
}
