import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/features/users/domain/usecases/delete_bookmarks_usecase.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/fetch_bookmarks_usecase.dart';
import 'package:stackoverflow_users/features/users/presentation/bloc/bookmarks/bookmarks.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  SOFBookmarksListPageBloc makeBloc() {
    http.Client client = TestUtils.makeUsersClient(
        response: http.Response(TestUtils.singleReputationJson, 201));
    SOFFetchBookmarksUseCase fetchBookmarksUseCase = SOFFetchBookmarksUseCase(
        repository: TestUtils.makeBookmarksRepository(client));
    SOFDeleteBookmarksUseCase deleteBookmarksUseCase =
        SOFDeleteBookmarksUseCase(
            repository: TestUtils.makeBookmarksRepository(client));

    return SOFBookmarksListPageBloc(
      fetchBookmarksUseCase: fetchBookmarksUseCase,
      deleteBookmarksUseCase: deleteBookmarksUseCase,
    );
  }

  group("bookmarks bloc tests", () {
    blocTest<SOFBookmarksListPageBloc, SOFBookmarksListPageState>(
      'Initialization returns empty if not able to read bookmarks',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFLoadBookmarksListPageEvent());
      },
      expect: () => <SOFBookmarksListPageState>[
        SOFBookmarksListPageLoadedState(users: []),
      ],
    );
  });
}
