import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_classes/base_usecase.dart';
import '../../../../core/models/failures.dart';
import '../entities/reputation.dart';
import '../repositories/users_repository.dart';

class SOFFetchReputationsUseCase
    implements SOFBaseUseCase<List<SOFReputation>, FetchReputationsListParams> {
  final SOFUsersRepository repository;

  SOFFetchReputationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SOFReputation>>> call(
      FetchReputationsListParams params) {
    return repository.fetchReputations(
      userId: params.userId,
      page: params.page,
    );
  }
}

class FetchReputationsListParams extends Equatable {
  final int page;
  final int userId;

  const FetchReputationsListParams({
    required this.userId,
    required this.page,
  });

  @override
  List<Object> get props => [
        userId,
        page,
      ];
}
