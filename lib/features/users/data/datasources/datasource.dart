import '../../../../core/base_classes/base_network_datasource.dart';
import '../../../../core/entities/sof_response.dart';

abstract class SOFUsersDataSource extends SOFBaseDataSource {
  /// Fetch users
  Future<SOFResponse> fetchUsers({required int page});

  /// Fetch reputation of user
  Future<SOFResponse> fetchReputation({required int userId, required int page});
}
