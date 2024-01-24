import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/features/users/domain/usecases/delete_bookmarks_usecase.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/fetch_users_usecase.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/save_bookmarks_usecase.dart';
import 'package:stackoverflow_users/features/users/presentation/bloc/users/users.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  SOFUsersListPageBloc makeBloc() {
    http.Client client = TestUtils.makeUsersClient(
        response: http.Response(TestUtils.singleUserJson, 201));
    SOFFetchUsersUseCase fetchUsersUseCase =
        SOFFetchUsersUseCase(repository: TestUtils.makeUserRepository(client));
    SOFSaveBookmarksUseCase saveBookmarksUseCase = SOFSaveBookmarksUseCase(
        repository: TestUtils.makeBookmarksRepository(client));
    SOFDeleteBookmarksUseCase deleteBookmarksUseCase =
        SOFDeleteBookmarksUseCase(
            repository: TestUtils.makeBookmarksRepository(client));

    return SOFUsersListPageBloc(
        fetchUsersUseCase: fetchUsersUseCase,
        saveBookmarksUseCase: saveBookmarksUseCase,
        deleteBookmarksUseCase: deleteBookmarksUseCase);
  }

  group("user bloc tests", () {
    blocTest<SOFUsersListPageBloc, SOFUsersListPageState>(
      'Initialization event loads users',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
      },
      expect: () => <SOFUsersListPageState>[
        SOFUsersListPageLoadingState(),
        SOFUsersListPageLoadedState(
            users: [TestUtils.user], page: 1, isLoading: false),
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
        SOFUsersListPageLoadedState(
            users: [TestUtils.user], page: 1, isLoading: false),
      ],
    );

    blocTest<SOFUsersListPageBloc, SOFUsersListPageState>(
      'Save bookmark flow ',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
        bloc.add(SOFSaveBookmarkEvent(user: TestUtils.user));
      },
      expect: () => <SOFUsersListPageState>[
        SOFUsersListPageLoadingState(),
        SOFUsersListPageLoadedState(
            users: [TestUtils.user], page: 1, isLoading: false),
      ],
    );

    blocTest<SOFUsersListPageBloc, SOFUsersListPageState>(
      'Delete bookmark flow ',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
        bloc.add(SOFRemoveBookmarkEvent(user: TestUtils.user));
      },
      expect: () => <SOFUsersListPageState>[
        SOFUsersListPageLoadingState(),
        SOFUsersListPageLoadedState(
            users: [TestUtils.user], page: 1, isLoading: false),
      ],
    );
  });
}
