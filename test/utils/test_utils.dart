import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:stackoverflow_users/core/configs/network_config.dart';

import '../features/users/data/datasources/users_network_datasource_test.mocks.dart';

class TestUtils {
  static final headersToPass = <String, String>{};

  static MockClient makeUsersClient({required http.Response response}) {
    headersToPass.addAll(<String, String>{
      "Accept": "application/json;charset=utf-t",
      "Accept-Language": "en",
    });
    final client = MockClient();
    when(client.get(
            Uri.parse(
                "https://${SOFNetworkConfig.usersBaseUrl}/${SOFNetworkConfig.apiVersion}/users?page=1&pagesize=${SOFNetworkConfig.pageSize}&site=stackoverflow"),
            headers: headersToPass))
        .thenAnswer((_) async => response);

    return client;
  }
}
