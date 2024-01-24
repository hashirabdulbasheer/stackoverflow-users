import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/delete_bookmarks_usecase.dart';
import '../../../domain/usecases/fetch_users_usecase.dart';
import '../../../domain/usecases/save_bookmarks_usecase.dart';
import 'users.dart';

class SOFUsersListPageBloc
    extends Bloc<SOFUsersListPageEvent, SOFUsersListPageState> {
  final SOFFetchUsersUseCase fetchUsersUseCase;
  final SOFSaveBookmarksUseCase saveBookmarksUseCase;
  final SOFDeleteBookmarksUseCase deleteBookmarksUseCase;

  SOFUsersListPageBloc({
    required this.fetchUsersUseCase,
    required this.saveBookmarksUseCase,
    required this.deleteBookmarksUseCase,
  }) : super(SOFUsersListPageLoadingState()) {
    // Init
    on<SOFInitializeUserListPageEvent>(
        (event, emit) => _onInitializeEvent(event, emit));

    // load event called on initial page load and when scrolled to bottom or refresh
    on<SOFUsersListPageLoadEvent>(
        (event, emit) => _onPageLoadEvent(event, emit));

    on<SOFSaveBookmarkEvent>(
        (event, emit) => _onSaveBookmarkEvent(event, emit));

    on<SOFRemoveBookmarkEvent>(
        (event, emit) => _onRemoveBookmarkEvent(event, emit));

    on<SOFForceLoadFromApiUserListPageEvent>(
        (event, emit) => _onForceLoadEvent(event, emit));
  }

  ///
  /// Handlers
  ///

  void _onInitializeEvent(event, emit) async {
    // fetch
    emit(SOFUsersListPageLoadingState());
    final response = await _fetchUsers(page: 1);
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
      // fetch
      SOFUsersListPageLoadedState currentState =
          state as SOFUsersListPageLoadedState;
      emit(currentState.copyWith(
        isLoading: true,
      ));
      final response = await _fetchUsers(page: event.page);
      if (response.isRight) {
        // success
        List<SOFUser> users = response.right;
        List<SOFUser> merged = _combine(currentState.users, users);
        emit(currentState.copyWith(
          users: merged,
          page: event.page,
          isLoading: false,
        ));
      }
    }
  }

  void _onSaveBookmarkEvent(event, emit) async {
    if (state is SOFUsersListPageLoadedState) {
      final response = await _saveBookmark(event.user);
      SOFUsersListPageLoadedState currentState =
          state as SOFUsersListPageLoadedState;
      if (response.isRight) {
        // success - load again
        add(SOFUsersListPageLoadEvent(page: currentState.page));
      } else {
        // failure
        emit(SOFUsersListPageErrorState(
          failure: response.left,
          currentPage: currentState.page,
        ));
      }
    }
  }

  void _onRemoveBookmarkEvent(event, emit) async {
    if (state is SOFUsersListPageLoadedState) {
      SOFUsersListPageLoadedState currentState =
          state as SOFUsersListPageLoadedState;
      final response = await _deleteBookmark(event.user);
      if (response.isRight) {
        // success - load again
        add(SOFUsersListPageLoadEvent(page: currentState.page));
      } else {
        // failure
        emit(SOFUsersListPageErrorState(
          failure: response.left,
          currentPage: currentState.page,
        ));
      }
    }
  }

  void _onForceLoadEvent(event, emit) async {
    // fetch
    emit(SOFUsersListPageLoadingState());
    final response = await _fetchUsers(page: 1, forceApi: true);
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

  // new users will have preference over previous for duplicates
  List<SOFUser> _combine(List<SOFUser> previousUsers, List<SOFUser> newUsers) {
    // Improve logic later on
    Map<int, SOFUser> shelf = {};
    for (SOFUser user in previousUsers) {
      shelf[user.id] = user;
    }
    for (SOFUser user in newUsers) {
      shelf[user.id] = user;
    }
    return List.from(shelf.values.toList());
  }

  /// FETCH
  Future<dynamic> _fetchUsers({required int page, bool? forceApi}) async {
    return await fetchUsersUseCase.call(FetchUsersListParams(
      page: page,
      forceLoadFromApi: forceApi,
    ));
  }

  Future<dynamic> _saveBookmark(SOFUser user) async {
    return saveBookmarksUseCase.call(SaveBookmarkParams(user: user));
  }

  Future<dynamic> _deleteBookmark(SOFUser user) async {
    return deleteBookmarksUseCase.call(DeleteBookmarkParams(user: user));
  }
}
