import 'package:http/http.dart' as http;

import '../../../../core/base_classes/base_network_datasource.dart';
import '../../../../core/configs/network_config.dart';
import '../../../../core/entities/enums/exception_type_enum.dart';
import '../../../../core/entities/exceptions.dart';
import '../../../../core/entities/sof_response.dart';

abstract class SOFUsersNetworkDataSource extends SOFBaseNetworkDataSource {
  /// Fetch users
  Future<SOFResponse> fetchUsers({required int page});
}

class SOFUsersNetworkDataSourceImpl implements SOFUsersNetworkDataSource {
  final http.Client client;

  SOFUsersNetworkDataSourceImpl({required this.client});

  ///
  /// Fetch the users for a page
  ///  - Returns the response as string if success
  ///  - Returns error status code if error
  ///
  @override
  Future<SOFResponse> fetchUsers({required int page}) async {
    Map<String, String> queryParameters = {};
    queryParameters[r'page'] = page.toString();
    queryParameters[r'pagesize'] = SOFNetworkConfig.pageSize.toString();
    queryParameters[r'site'] = "stackoverflow";

    var finalUrl = Uri.https(SOFNetworkConfig.usersBaseUrl,
        "/${SOFNetworkConfig.apiVersion}/users", queryParameters);

    final headersToPass = <String, String>{};
    headersToPass.addAll(<String, String>{
      "Accept": "application/json;charset=utf-t",
      "Accept-Language": "en",
    });

    http.Response response = await client.get(finalUrl, headers: headersToPass);

    // Responses
    if (response.statusCode == 201 || response.statusCode == 200) {
      return SOFResponse(isSuccessful: true, body: response.body);
    } else {
      // Error
      throw ServerException(
          type: SOFExceptionType.network,
          message:
              "${SOFExceptionType.network.rawString()}: ${response.statusCode}");
    }
  }
}
