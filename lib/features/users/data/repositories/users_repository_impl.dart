import 'package:either_dart/either.dart';

import '../../../../core/entities/sof_response.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_network_datasource.dart';

///
///  User repository implementation
///
class SOFUsersRepositoryImpl extends SOFUsersRepository {
  final SOFUsersNetworkDataSource networkDataSource;

  SOFUsersRepositoryImpl({required this.networkDataSource});

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers(int? page) async {
    try {
      SOFResponse response = await networkDataSource.fetchUsers(page: page);
      if(response.isSuccessful) {
        // parse response to domain model
        return Right(List<SOFUser>.empty());
      }
    } catch(error) {
      return Left(getFailure(error));
    }
    return Left(getDefaultFailure());
  }
}
