import 'package:equatable/equatable.dart';

import '../../../../../core/models/failures.dart';
import '../../../domain/entities/user.dart';

abstract class SOFUsersListPageState {}

/// Loading
class SOFUsersListPageLoadingState extends SOFUsersListPageState {}

/// Loaded
class SOFUsersListPageLoadedState extends SOFUsersListPageState
    with EquatableMixin {
  final List<SOFUser> users;
  final int page;
  final bool isLoading;

  SOFUsersListPageLoadedState(
      {required this.users, required this.page, required this.isLoading});

  SOFUsersListPageLoadedState copyWith({
    List<SOFUser>? users,
    int? page,
    bool? isLoading,
  }) {
    return SOFUsersListPageLoadedState(
        users: users ?? this.users,
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [users, page, isLoading];
}

/// Error
class SOFUsersListPageErrorState extends SOFUsersListPageState {
  final Failure failure;
  final int currentPage;

  SOFUsersListPageErrorState(
      {required this.failure, required this.currentPage});

  List<Object> get props => [failure, currentPage];
}
