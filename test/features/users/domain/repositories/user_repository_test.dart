import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:stackoverflow_users/core/models/enums/failure_type_enum.dart';
import 'package:stackoverflow_users/core/models/failures.dart';
import 'package:stackoverflow_users/features/users/data/datasources/users_network_datasource.dart';
import 'package:stackoverflow_users/features/users/data/repositories/users_repository_impl.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/users_repository.dart';

import '../../../../utils/test_utils.dart';

@GenerateMocks([http.Client])
void main() {
  String emptyUsersJson = '{ "items": []}';
  String singleUserJson =
      '{ "items": [{"badge_counts":{"bronze":9231,"silver":9183,"gold":873},"account_id":11683,"is_employee":false,"last_modified_date":1704297305,"last_access_date":1705927755,"reputation_change_year":3517,"reputation_change_quarter":3517,"reputation_change_month":3517,"reputation_change_week":196,"reputation_change_day":130,"reputation":1444575,"creation_date":1222430705,"user_type":"registered","user_id":22656,"accept_rate":86,"location":"Reading,UnitedKingdom","website_url":"http://csharpindepth.com","link":"https://stackoverflow.com/users/22656/jon-skeet","profile_image":"https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG","display_name":"JonSkeet"}]}';

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
                response: http.Response(emptyUsersJson, 200))));
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
                response: http.Response(singleUserJson, 500))));
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
                response: http.Response(singleUserJson, 200))));
    Either result = await repository.fetchUsers(page: 1);
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect((result.right as List).length == 1, true);
  });
}
