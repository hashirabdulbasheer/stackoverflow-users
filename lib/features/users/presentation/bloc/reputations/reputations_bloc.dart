import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/reputation.dart';
import '../../../domain/usecases/fetch_reputations_usecase.dart';
import 'reputations.dart';

class SOFReputationsListPageBloc
    extends Bloc<SOFReputationsListPageEvent, SOFReputationsListPageState> {
  final SOFFetchReputationsUseCase fetchReputationsUseCase;

  SOFReputationsListPageBloc({required this.fetchReputationsUseCase})
      : super(SOFReputationsListPageLoadingState()) {
    // Init
    on<SOFInitializeReputationsListPageEvent>(
        (event, emit) => _onInitializeEvent(event, emit));

    on<SOFReputationsListPageLoadEvent>(
        (event, emit) => _onPageLoadEvent(event, emit));
  }

  ///
  /// Handlers
  ///

  void _onInitializeEvent(event, emit) async {
    // fetch
    final response = await _fetchReputations(event.userId, 1);
    if (response.isRight) {
      // success
      List<SOFReputation> reputations = response.right;
      emit(SOFReputationsListPageLoadedState(
        reputations: reputations,
        page: 1,
        isLoading: false,
        userId: event.userId,
      ));
    } else {
      // failure
      emit(SOFReputationsListPageErrorState(
        failure: response.left,
        currentPage: 1,
      ));
    }
  }

  void _onPageLoadEvent(event, emit) async {
    if (state is SOFReputationsListPageLoadedState) {
      // fetch
      final response = await _fetchReputations(event.userId, event.page);
      if (response.isRight) {
        // success
        SOFReputationsListPageLoadedState currentState =
            state as SOFReputationsListPageLoadedState;
        List<SOFReputation> reputations = response.right;
        List<SOFReputation> merged = currentState.reputations + reputations;
        emit(currentState.copyWith(
          reputations: merged,
          page: event.page,
          isLoading: false,
        ));
      }
    }
  }

  /// FETCH
  Future<dynamic> _fetchReputations(int userId, int page) async {
    return await fetchReputationsUseCase.call(FetchReputationsListParams(
      userId: userId,
      page: page,
    ));
  }
}
