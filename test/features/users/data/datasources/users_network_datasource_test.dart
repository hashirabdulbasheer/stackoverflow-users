import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:stackoverflow_users/core/entities/enums/exception_type_enum.dart';
import 'package:stackoverflow_users/core/entities/exceptions.dart';
import 'package:stackoverflow_users/core/entities/sof_response.dart';
import 'package:stackoverflow_users/features/users/data/datasources/network/users_network_datasource.dart';

import '../../../../utils/test_utils.dart';

///
/// Test cases for users network data source
///

@GenerateMocks([http.Client])
void main() {
  /// Testcases

  test('FetchUsers should throw Server exception in case of network errors',
      () async {
    final client = TestUtils.makeUsersClient(
        response: http.Response(TestUtils.errorJson, 403));
    SOFUsersNetworkDataSource sut =
        SOFUsersNetworkDataSourceImpl(client: client);

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
    final client =
        TestUtils.makeUsersClient(response: http.Response("body", 200));
    SOFUsersNetworkDataSource sut =
        SOFUsersNetworkDataSourceImpl(client: client);

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
    final client =
        TestUtils.makeUsersClient(response: http.Response("body", 201));
    SOFUsersNetworkDataSource sut =
        SOFUsersNetworkDataSourceImpl(client: client);

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
