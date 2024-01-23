import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/core/models/enums/failure_type_enum.dart';
import 'package:stackoverflow_users/core/models/failures.dart';
import 'package:stackoverflow_users/features/users/data/datasources/network/users_network_datasource.dart';
import 'package:stackoverflow_users/features/users/data/repositories/users_repository_impl.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/users_repository.dart';

import '../../../../utils/test_utils.dart';

void main() {
  test(
      'Repository should return failure for success network response for fetchUsers with empty json',
      () async {
    SOFUsersRepository repository = SOFUsersRepositoryImpl(
        networkDataSource: SOFUsersNetworkDataSourceImpl(
            client:
                TestUtils.makeUsersClient(response: http.Response("{}", 201))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.general);
  });

  test(
      'Repository should return failure for success network response for fetchUsers with empty body',
      () async {
    SOFUsersRepository repository = SOFUsersRepositoryImpl(
        networkDataSource: SOFUsersNetworkDataSourceImpl(
            client:
                TestUtils.makeUsersClient(response: http.Response("", 201))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.general);
  });

  test(
      'Repository should return failure for failed network response for fetchUsers with network errors',
      () async {
    SOFUsersRepository repository = SOFUsersRepositoryImpl(
        networkDataSource: SOFUsersNetworkDataSourceImpl(
            client:
                TestUtils.makeUsersClient(response: http.Response("", 500))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.network);
  });

  test('Repository should return success for responses with valid empty users',
      () async {
    SOFUsersRepository repository = SOFUsersRepositoryImpl(
        networkDataSource: SOFUsersNetworkDataSourceImpl(
            client: TestUtils.makeUsersClient(
                response: http.Response(TestUtils.emptyUsersJson, 200))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect((result.right as List).isEmpty, true);
  });

  test(
      'Repository should return failure for failed network response with error status but valid json',
      () async {
    SOFUsersRepository repository = SOFUsersRepositoryImpl(
        networkDataSource: SOFUsersNetworkDataSourceImpl(
            client: TestUtils.makeUsersClient(
                response: http.Response(TestUtils.singleUserJson, 500))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.network);
  });

  test('Repository should return one user for responses with valid one users',
      () async {
    SOFUsersRepository repository = SOFUsersRepositoryImpl(
        networkDataSource: SOFUsersNetworkDataSourceImpl(
            client: TestUtils.makeUsersClient(
                response: http.Response(TestUtils.singleUserJson, 200))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect((result.right as List).length == 1, true);
  });
}
