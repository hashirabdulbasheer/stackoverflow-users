import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';

abstract class SOFUsersListPageEvent {}

class SOFInitializeUserListPageEvent extends SOFUsersListPageEvent {}

// Called on initial page load and when scrolled to bottom and refreshed
class SOFUsersListPageLoadEvent extends SOFUsersListPageEvent
    with EquatableMixin {
  final int page;

  SOFUsersListPageLoadEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class SOFSaveBookmarkEvent extends SOFUsersListPageEvent
    with EquatableMixin {
  final SOFUser user;

  SOFSaveBookmarkEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
