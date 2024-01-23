import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_classes/base_usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/delete_bookmarks_usecase.dart';
import '../../../domain/usecases/fetch_bookmarks_usecase.dart';
import '../../../domain/usecases/save_bookmarks_usecase.dart';
import 'bookmarks.dart';

class SOFBookmarksListPageBloc
    extends Bloc<SOFBookmarkListPageEvent, SOFBookmarksListPageState> {
  final SOFFetchBookmarksUseCase fetchBookmarksUseCase;
  final SOFSaveBookmarksUseCase saveBookmarksUseCase;
  final SOFDeleteBookmarksUseCase deleteBookmarksUseCase;

  SOFBookmarksListPageBloc({
    required this.fetchBookmarksUseCase,
    required this.saveBookmarksUseCase,
    required this.deleteBookmarksUseCase,
  }) : super(SOFBookmarksListPageLoadingState()) {
    on<SOFLoadBookmarksListPageEvent>(
        (event, emit) => _onLoadEvent(event, emit));

    on<SOFDeleteBookmarkListPageEvent>(
        (event, emit) => _onDeleteEvent(event, emit));

    on<SOFSaveBookmarkListPageEvent>(
        (event, emit) => _onSaveEvent(event, emit));
  }

  ///
  /// Handlers
  ///

  void _onLoadEvent(event, emit) async {
    // fetch
    final response = await _fetchBookmarks();
    if (response.isRight) {
      // success
      List<SOFUser> users = response.right;
      emit(SOFBookmarksListPageLoadedState(users: users));
    } else {
      // failure
      emit(SOFBookmarksListPageErrorState(failure: response.left));
    }
  }

  void _onDeleteEvent(event, emit) async {
    final response = await _deleteBookmark(event.user);
    if (response.isRight) {
      // success - load again
      add(SOFLoadBookmarksListPageEvent());
    } else {
      // failure
      emit(SOFBookmarksListPageErrorState(failure: response.left));
    }
  }

  void _onSaveEvent(event, emit) async {
    final response = await _saveBookmark(event.user);
    if (response.isRight) {
      // success - load again
      add(SOFLoadBookmarksListPageEvent());
    } else {
      // failure
      emit(SOFBookmarksListPageErrorState(failure: response.left));
    }
  }

  /// FETCH
  Future<dynamic> _fetchBookmarks() async {
    return await fetchBookmarksUseCase.call(NoParams());
  }

  Future<dynamic> _deleteBookmark(SOFUser user) async {
    return deleteBookmarksUseCase.call(DeleteBookmarkParams(user: user));
  }

  Future<dynamic> _saveBookmark(SOFUser user) async {
    return saveBookmarksUseCase.call(SaveBookmarkParams(user: user));
  }
}
