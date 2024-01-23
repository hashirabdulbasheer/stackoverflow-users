import 'package:equatable/equatable.dart';

import '../../../../../core/models/failures.dart';
import '../../../domain/entities/reputation.dart';

abstract class SOFReputationsListPageState {}

/// Loading
class SOFReputationsListPageLoadingState extends SOFReputationsListPageState {}

/// Loaded
class SOFReputationsListPageLoadedState extends SOFReputationsListPageState
    with EquatableMixin {
  final List<SOFReputation> reputations;
  final int userId;
  final int page;
  final bool isLoading;

  SOFReputationsListPageLoadedState({
    required this.reputations,
    required this.userId,
    required this.page,
    required this.isLoading,
  });

  SOFReputationsListPageLoadedState copyWith({
    List<SOFReputation>? reputations,
    int? userId,
    int? page,
    bool? isLoading,
  }) {
    return SOFReputationsListPageLoadedState(
        reputations: reputations ?? this.reputations,
        userId: userId ?? this.userId,
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [
        reputations,
        userId,
        page,
        isLoading,
      ];
}

/// Error
class SOFReputationsListPageErrorState extends SOFReputationsListPageState {
  final Failure failure;
  final int currentPage;

  SOFReputationsListPageErrorState(
      {required this.failure, required this.currentPage});

  List<Object> get props => [failure, currentPage];
}
