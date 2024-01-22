import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackoverflow_users/core/configs/network_config.dart';
import 'package:stackoverflow_users/core/entities/SOResponse.dart';
import 'package:stackoverflow_users/features/users/data/users_network_datasource.dart';

import 'users_network_datasource_test.mocks.dart';

///
/// Test cases for users network data source
///

@GenerateMocks([http.Client])
void main() {

  /// Utils
  String errorJson =
      '{"error_id": 403, "error_message": "someError", "error_name": "network_error"}';

  SOUsersNetworkDataSource makeSut({required http.Client client}) {
    return SOUsersNetworkDataSourceImpl(client: client);
  }

  final headersToPass = <String, String>{};
  headersToPass.addAll(<String, String>{
    "Accept": "application/json;charset=utf-t",
    "Accept-Language": "en",
  });

  MockClient makeUsersClient({required http.Response response}) {
    final client = MockClient();
    when(client.get(
            Uri.parse(
                "https://${SONetworkConfig.usersBaseUrl}/${SONetworkConfig.apiVersion}/users?page=1&pagesize=${SONetworkConfig.pageSize}&site=stackoverflow"),
            headers: headersToPass))
        .thenAnswer((_) async => response);

    return client;
  }

  /// Testcases

  test('LoadUsers should return error response in case of network errors',
      () async {
    final client = makeUsersClient(response: http.Response(errorJson, 403));
    SOUsersNetworkDataSource sut = makeSut(client: client);

    SOResponse response = await sut.fetchUsers(page: 1);

    expect(response.isSuccessful, false);
    expect(response.statusCode, 403);
    expect(response.body, null);
  });
}
