import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/features/users/domain/usecases/fetch_reputations_usecase.dart';
import 'package:stackoverflow_users/features/users/presentation/bloc/reputations/reputations.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  SOFReputationsListPageBloc makeBloc() {
    http.Client client = TestUtils.makeReputationsClient(
        response: http.Response(TestUtils.singleReputationJson, 201));
    SOFFetchReputationsUseCase fetchReputationsUseCase =
        SOFFetchReputationsUseCase(
            repository: TestUtils.makeUserRepository(client));

    return SOFReputationsListPageBloc(
      fetchReputationsUseCase: fetchReputationsUseCase,
    );
  }

  group("reputation bloc tests", () {
    blocTest<SOFReputationsListPageBloc, SOFReputationsListPageState>(
      'Initialization event loads reputations',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeReputationsListPageEvent(userId: 22656));
      },
      expect: () => <SOFReputationsListPageState>[
        SOFReputationsListPageLoadedState(
            page: 1,
            isLoading: false,
            reputations: [TestUtils.reputation],
            userId: 22656),
      ],
    );

    blocTest<SOFReputationsListPageBloc, SOFReputationsListPageState>(
      'Page load event loads reputations',
      build: () => makeBloc(),
      act: (bloc) {
        bloc.add(SOFInitializeReputationsListPageEvent(userId: 22656));
        bloc.add(SOFReputationsListPageLoadEvent(page: 1, userId: 22656));
      },
      expect: () => <SOFReputationsListPageState>[
        SOFReputationsListPageLoadedState(
            page: 1,
            isLoading: false,
            reputations: [TestUtils.reputation],
            userId: 22656),
        SOFReputationsListPageLoadedState(
            page: 1,
            isLoading: false,
            reputations: [TestUtils.reputation, TestUtils.reputation],
            userId: 22656)
      ],
    );
  });
}
