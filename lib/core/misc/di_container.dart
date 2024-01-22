import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/users/data/datasources/users_network_datasource.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/domain/repositories/users_repository.dart';
import '../../features/users/domain/usecases/fetch_users_usecase.dart';

final sl = GetIt.instance;

class SOFDiContainer {
  static Future<void> init({required http.Client networkClient}) async {
    /// network sources
    sl.registerFactory<SOFUsersNetworkDataSource>(
        () => SOFUsersNetworkDataSourceImpl(client: networkClient));

    /// repositories
    sl.registerFactory<SOFUsersRepository>(
        () => SOFUsersRepositoryImpl(networkDataSource: sl()));

    /// use-cases
    sl.registerFactory<SOFFetchUsersUseCase>(
        () => SOFFetchUsersUseCase(repository: sl()));
  }
}
