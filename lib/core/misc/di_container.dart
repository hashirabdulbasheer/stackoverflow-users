import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/users/data/datasources/network/users_network_datasource.dart';
import '../../features/users/data/repositories/bookmarks_repository_impl.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/domain/repositories/bookmarks_repository.dart';
import '../../features/users/domain/repositories/users_repository.dart';
import '../../features/users/domain/usecases/delete_bookmarks_usecase.dart';
import '../../features/users/domain/usecases/fetch_bookmarks_usecase.dart';
import '../../features/users/domain/usecases/fetch_reputations_usecase.dart';
import '../../features/users/domain/usecases/fetch_users_usecase.dart';
import '../../features/users/domain/usecases/save_bookmarks_usecase.dart';
import '../db/hive_manager.dart';

final sl = GetIt.instance;

class SOFDiContainer {
  static Future<void> init({required http.Client networkClient}) async {
    /// network sources
    sl.registerFactory<SOFUsersNetworkDataSource>(
        () => SOFUsersNetworkDataSourceImpl(client: networkClient));

    /// repositories
    sl.registerFactory<SOFUsersRepository>(() => SOFUsersRepositoryImpl(
          networkDataSource: sl(),
          localDataSource: sl(),
          bookmarkDataSource: sl(),
        ));
    sl.registerFactory<SOFBookmarksRepository>(() => SOFBookmarksRepositoryImpl(
          networkDataSource: sl(),
          bookmarkDataSource: sl(),
        ));

    /// use-cases
    sl.registerFactory<SOFFetchUsersUseCase>(
        () => SOFFetchUsersUseCase(repository: sl()));
    sl.registerFactory<SOFFetchBookmarksUseCase>(
        () => SOFFetchBookmarksUseCase(repository: sl()));
    sl.registerFactory<SOFSaveBookmarksUseCase>(
        () => SOFSaveBookmarksUseCase(repository: sl()));
    sl.registerFactory<SOFDeleteBookmarksUseCase>(
        () => SOFDeleteBookmarksUseCase(repository: sl()));
    sl.registerFactory<SOFFetchReputationsUseCase>(
        () => SOFFetchReputationsUseCase(repository: sl()));

    /// Hive db
    sl.registerLazySingleton<SOFUsersLocalDataSource>(
        () => SOFUsersLocalDataSource());
    sl.registerLazySingleton<SOFUsersBookmarkDataSource>(
        () => SOFUsersBookmarkDataSource());
  }
}
