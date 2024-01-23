import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/fetch_users_usecase.dart';
import 'users_event.dart';
import 'users_state.dart';

class SOFUsersListPageBloc
    extends Bloc<SOFUsersListPageEvent, SOFUsersListPageState> {
  final SOFFetchUsersUseCase fetchUsersUseCase;

  SOFUsersListPageBloc({required this.fetchUsersUseCase})
      : super(SOFUsersListPageLoadingState()) {
    // load event called on initial page load and when scrolled to bottom or refresh
    on<SOFUsersListPageLoadEvent>((event, emit) => _onPageLoadEvent(event, emit));

  }

  /// Handlers
  void _onPageLoadEvent(event, emit) async {
    final response =
        await fetchUsersUseCase.call(FetchUsersListParams(page: event.page));
    if (response.isRight) {
      // success
      List<SOFUser> users = response.right;
      emit(SOFUsersListPageLoadedState(users: users, page: event.page));
    } else {
      // failure
      emit(SOFUsersListPageErrorState(failure: response.left));
    }
  }
}
