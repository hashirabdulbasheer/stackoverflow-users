import 'package:equatable/equatable.dart';

import '../../../../../core/models/failures.dart';
import '../../../domain/entities/user.dart';

abstract class SOFBookmarksListPageState {}

/// Loading
class SOFBookmarksListPageLoadingState extends SOFBookmarksListPageState {}

/// Loaded
class SOFBookmarksListPageLoadedState extends SOFBookmarksListPageState
    with EquatableMixin {
  final List<SOFUser> users;

  SOFBookmarksListPageLoadedState({required this.users});

  SOFBookmarksListPageLoadedState copyWith({List<SOFUser>? users}) {
    return SOFBookmarksListPageLoadedState(users: users ?? this.users);
  }

  @override
  List<Object?> get props => [users];
}

/// Error
class SOFBookmarksListPageErrorState extends SOFBookmarksListPageState {
  final Failure failure;

  SOFBookmarksListPageErrorState({required this.failure});

  List<Object> get props => [failure];
}
