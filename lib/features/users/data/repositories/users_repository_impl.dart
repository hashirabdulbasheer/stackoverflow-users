import '../../domain/repositories/users_repository.dart';
import '../datasources/users_network_datasource.dart';

class SOUsersRepositoryImpl extends SOUsersRepository {
  final SOUsersNetworkDataSource networkDataSource;

  SOUsersRepositoryImpl({required this.networkDataSource});
}
