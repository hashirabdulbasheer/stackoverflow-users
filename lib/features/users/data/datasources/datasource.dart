import '../../../../core/base_classes/base_network_datasource.dart';
import '../../../../core/entities/sof_response.dart';

abstract class SOFUsersDataSource extends SOFBaseDataSource {}

abstract class SOFUsersLocalDataSource extends SOFUsersDataSource {
  /// Fetch users
  Future<SOFResponse> fetchUsers({required int page});

  /// Save
  Future<bool> saveUsersPage({required int page, required String responseJson});
}

abstract class SOFUsersNetworkDataSource extends SOFUsersDataSource {
  /// Fetch users
  Future<SOFResponse> fetchUsers({required int page});

  /// Fetch reputation of user
  Future<SOFResponse> fetchReputation({required int userId, required int page});
}
