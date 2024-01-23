import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_classes/base_usecase.dart';
import '../../../../core/models/failures.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class SOFFetchUsersUseCase
    implements SOFBaseUseCase<List<SOFUser>, FetchUsersListParams> {
  final SOFUsersRepository repository;

  SOFFetchUsersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SOFUser>>> call(FetchUsersListParams params) {
    return repository.fetchUsers(
      page: params.page,
      forceApi: params.forceLoadFromApi,
    );
  }
}

class FetchUsersListParams extends Equatable {
  final int page;
  final bool? forceLoadFromApi;

  const FetchUsersListParams({required this.page, this.forceLoadFromApi});

  @override
  List<Object?> get props => [
        page,
        forceLoadFromApi,
      ];
}
