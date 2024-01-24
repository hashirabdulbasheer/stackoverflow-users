import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/features/users/domain/usecases/fetch_reputations_usecase.dart';
import 'package:stackoverflow_users/features/users/presentation/bloc/reputations/reputations.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  SOFReputationsListPageBloc makeBloc() {
    http.Client client = TestUtils.makeUsersClient(
        response: http.Response(TestUtils.singleUserJson, 201));
    SOFFetchReputationsUseCase fetchReputationsUseCase =
        SOFFetchReputationsUseCase(
            repository: TestUtils.makeUserRepository(client));

    return SOFReputationsListPageBloc(
      fetchReputationsUseCase: fetchReputationsUseCase,
    );
  }

  group("user bloc tests", () {
    blocTest<SOFReputationsListPageBloc, SOFReputationsListPageState>(
      'Initialization event loads users',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeReputationsListPageEvent(userId: 22656));
      },
      expect: () => <SOFReputationsListPageState>[
        SOFReputationsListPageLoadingState(),
        SOFReputationsListPageLoadedState(
            page: 1, isLoading: false, reputations: [], userId: 22656),
      ],
    );

    /*
    blocTest<SOFReputationsListPageBloc, SOFReputationsListPageState>(
      'Page load event loads same user if duplicate',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
        bloc.add(SOFReputationsListPageLoadEvent(page: 1));
      },
      expect: () => <SOFReputationsListPageState>[
        SOFReputationsListPageLoadingState(),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: false),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: true),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: false),
      ],
    );

    blocTest<SOFReputationsListPageBloc, SOFReputationsListPageState>(
      'Save bookmark flow ',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
        bloc.add(SOFSaveBookmarkEvent(user: user));
      },
      expect: () => <SOFReputationsListPageState>[
        SOFReputationsListPageLoadingState(),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: false),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: true),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: false),
      ],
    );

    blocTest<SOFReputationsListPageBloc, SOFReputationsListPageState>(
      'Delete bookmark flow ',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeUserListPageEvent());
        bloc.add(SOFRemoveBookmarkEvent(user: user));
      },
      expect: () => <SOFReputationsListPageState>[
        SOFReputationsListPageLoadingState(),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: false),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: true),
        SOFReputationsListPageLoadedState(
            users: [user], page: 1, isLoading: false),
      ],
    );

     */
  });
}
