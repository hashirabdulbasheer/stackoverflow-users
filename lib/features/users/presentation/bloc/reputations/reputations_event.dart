import 'package:equatable/equatable.dart';

abstract class SOFReputationsListPageEvent {}

class SOFInitializeReputationsListPageEvent
    extends SOFReputationsListPageEvent with EquatableMixin {
  final int userId;

  SOFInitializeReputationsListPageEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SOFReputationsListPageLoadEvent extends SOFReputationsListPageEvent
    with EquatableMixin {
  final int page;
  final int userId;

  SOFReputationsListPageLoadEvent({required this.userId, required this.page});

  @override
  List<Object?> get props => [
        userId,
        page,
      ];
}
