import 'package:either_dart/src/either.dart';
import 'package:stackoverflow_users/core/models/failures.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_network_datasource.dart';

class SOUsersRepositoryImpl extends SOUsersRepository {
  final SOUsersNetworkDataSource networkDataSource;

  SOUsersRepositoryImpl({required this.networkDataSource});

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers() {
    // TODO: implement fetchUsers
    throw UnimplementedError();
  }
}
