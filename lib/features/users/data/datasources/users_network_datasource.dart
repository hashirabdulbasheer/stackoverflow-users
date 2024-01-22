import 'package:http/http.dart' as http;

import '../../../../core/base_classes/base_network_datasource.dart';
import '../../../../core/configs/network_config.dart';
import '../../../../core/entities/so_response.dart';
import '../../../../core/entities/exceptions.dart';
import '../../../../core/enums/error_type_enum.dart';

abstract class SOUsersNetworkDataSource extends SOBaseNetworkDataSource {
  /// Fetch users
  Future<SOResponse> fetchUsers({int page});
}

class SOUsersNetworkDataSourceImpl implements SOUsersNetworkDataSource {
  final http.Client client;

  SOUsersNetworkDataSourceImpl({required this.client});

  ///
  /// Fetch the users for a page
  ///  - Returns the response as string if success
  ///  - Returns error status code if error
  ///
  @override
  Future<SOResponse> fetchUsers({int page = 1}) async {
    Map<String, String> queryParameters = {};
    queryParameters[r'page'] = page.toString();
    queryParameters[r'pagesize'] = SONetworkConfig.pageSize.toString();
    queryParameters[r'site'] = "stackoverflow";

    var finalUrl = Uri.https(SONetworkConfig.usersBaseUrl,
        "/${SONetworkConfig.apiVersion}/users", queryParameters);

    final headersToPass = <String, String>{};
    headersToPass.addAll(<String, String>{
      "Accept": "application/json;charset=utf-t",
      "Accept-Language": "en",
    });

    http.Response response = await client.get(finalUrl, headers: headersToPass);

    // Responses
    if (response.statusCode == 201 || response.statusCode == 200) {
      return SOResponse(isSuccessful: true, body: response.body);
    } else {
      // Error
      throw ServerException(
          type: SOErrorType.network,
          message:
              "${SOErrorType.network.rawString()}: ${response.statusCode}");
    }
  }
}
