import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/fetch_users_usecase.dart';
import 'users.dart';

class SOFUsersListPageBloc
    extends Bloc<SOFUsersListPageEvent, SOFUsersListPageState> {
  final SOFFetchUsersUseCase fetchUsersUseCase;

  SOFUsersListPageBloc({required this.fetchUsersUseCase})
      : super(SOFUsersListPageLoadingState()) {
    // Init
    on<SOFInitializeUserListPageEvent>(
        (event, emit) => _onInitializeEvent(event, emit));

    // load event called on initial page load and when scrolled to bottom or refresh
    on<SOFUsersListPageLoadEvent>(
        (event, emit) => _onPageLoadEvent(event, emit));
  }

  ///
  /// Handlers
  ///

  void _onInitializeEvent(event, emit) async {
    // fetch
    final response = await _fetchUsers(1);
    if (response.isRight) {
      // success
      List<SOFUser> users = response.right;
      emit(SOFUsersListPageLoadedState(
        users: users,
        page: 1,
        isLoading: false,
      ));
    } else {
      // failure
      emit(SOFUsersListPageErrorState(
        failure: response.left,
        currentPage: 1,
      ));
    }
  }

  void _onPageLoadEvent(event, emit) async {
    if (state is SOFUsersListPageLoadedState) {
      SOFUsersListPageLoadedState currentState =
          state as SOFUsersListPageLoadedState;
      // loading -> true
      emit(currentState.copyWith(isLoading: true));

      // fetch
      final response = await _fetchUsers(event.page);
      if (response.isRight) {
        // success
        List<SOFUser> users = response.right;
        List<SOFUser> merged = currentState.users + users;
        emit(currentState.copyWith(
          users: merged,
          page: event.page,
          isLoading: false,
        ));
      } else {
        // failure
        emit(currentState.copyWith(isLoading: false));
        emit(SOFUsersListPageErrorState(
          failure: response.left,
          currentPage: event.page,
        ));
      }
    }
  }

  /// FETCH
  Future<dynamic> _fetchUsers(int page) async {
    return await fetchUsersUseCase.call(FetchUsersListParams(page: page));
  }
}
