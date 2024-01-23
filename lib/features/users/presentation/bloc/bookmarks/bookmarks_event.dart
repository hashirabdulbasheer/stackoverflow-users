import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';

abstract class SOFBookmarkListPageEvent {}

class SOFLoadBookmarksListPageEvent extends SOFBookmarkListPageEvent {}

class SOFDeleteBookmarkListPageEvent extends SOFBookmarkListPageEvent
    with EquatableMixin {
  final SOFUser user;

  SOFDeleteBookmarkListPageEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
