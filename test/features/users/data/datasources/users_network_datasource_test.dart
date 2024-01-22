import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackoverflow_users/core/configs/network_config.dart';
import 'package:stackoverflow_users/core/entities/enums/exception_type_enum.dart';
import 'package:stackoverflow_users/core/entities/sof_response.dart';
import 'package:stackoverflow_users/core/entities/exceptions.dart';
import 'package:stackoverflow_users/features/users/data/datasources/users_network_datasource.dart';

import 'users_network_datasource_test.mocks.dart';

///
/// Test cases for users network data source
///

@GenerateMocks([http.Client])
void main() {
  /// Utils
  String errorJson =
      '{"error_id": 403, "error_message": "someError", "error_name": "network_error"}';

  SOFUsersNetworkDataSource makeSut({required http.Client client}) {
    return SOFUsersNetworkDataSourceImpl(client: client);
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
                "https://${SOFNetworkConfig.usersBaseUrl}/${SOFNetworkConfig.apiVersion}/users?page=1&pagesize=${SOFNetworkConfig.pageSize}&site=stackoverflow"),
            headers: headersToPass))
        .thenAnswer((_) async => response);

    return client;
  }

  /// Testcases

  test('FetchUsers should throw Server exception in case of network errors',
      () async {
    final client = makeUsersClient(response: http.Response(errorJson, 403));
    SOFUsersNetworkDataSource sut = makeSut(client: client);

    SOFResponse? response;
    try {
      response = await sut.fetchUsers(page: 1);
    } catch (error) {
      expect(error is ServerException, true);
      expect((error as ServerException).type, SOFExceptionType.network);
    }

    expect(response == null, true);
  });

  test(
      'FetchUsers should return success response in case api returns status code 200',
      () async {
    final client = makeUsersClient(response: http.Response("body", 200));
    SOFUsersNetworkDataSource sut = makeSut(client: client);

    SOFResponse? response;
    Exception? exception;
    try {
      response = await sut.fetchUsers(page: 1);
    } on Exception catch (error) {
      exception = error;
    }

    expect(exception == null, true);
    expect(response?.isSuccessful, true);
    expect(response?.body, "body");
  });

  test(
      'FetchUsers should return success response in case api returns status code 201',
      () async {
    final client = makeUsersClient(response: http.Response("body", 201));
    SOFUsersNetworkDataSource sut = makeSut(client: client);

    SOFResponse? response;
    Exception? exception;
    try {
      response = await sut.fetchUsers(page: 1);
    } on Exception catch (error) {
      exception = error;
    }

    expect(exception == null, true);
    expect(response?.isSuccessful, true);
    expect(response?.body, "body");
  });
}
