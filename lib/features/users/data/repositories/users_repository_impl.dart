import 'package:either_dart/either.dart';
import 'package:stackoverflow_users/core/models/failures.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_network_datasource.dart';

class SOFUsersRepositoryImpl extends SOFUsersRepository {
  final SOFUsersNetworkDataSource networkDataSource;

  SOFUsersRepositoryImpl({required this.networkDataSource});

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers() {
    // TODO: implement fetchUsers
    throw UnimplementedError();
  }
}
