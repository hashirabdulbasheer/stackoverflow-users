import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/core/models/enums/failure_type_enum.dart';
import 'package:stackoverflow_users/core/models/failures.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/users_repository.dart';

import '../../../../utils/test_utils.dart';

void main() {
  /// Users list fetching
  group("Users list fetching", () {
    test(
        'Repository should return success with empty user list for success network response for fetchUsers with empty json',
        () async {
      http.Client client =
          TestUtils.makeUsersClient(response: http.Response("{}", 201));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchUsers(page: 1, forceApi: true);

      expect(result.isLeft, false);
      expect(result.isRight, true);
      expect(result.right, []);
    });

    test(
        'Repository should return failure for success network response for fetchUsers with empty body',
        () async {
      http.Client client =
          TestUtils.makeUsersClient(response: http.Response("", 201));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchUsers(page: 1, forceApi: true);

      expect(result.isLeft, true);
      expect(result.isRight, false);
      expect((result.left as ServerFailure).type, SOFFailureType.general);
    });

    test(
        'Repository should return failure for failed network response for fetchUsers with network errors',
        () async {
      http.Client client =
          TestUtils.makeUsersClient(response: http.Response("", 500));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchUsers(page: 1, forceApi: true);

      expect(result.isLeft, true);
      expect(result.isRight, false);
      expect((result.left as ServerFailure).type, SOFFailureType.network);
    });

    test(
        'Repository should return success for responses with valid empty users',
        () async {
      http.Client client = TestUtils.makeUsersClient(
          response: http.Response(TestUtils.emptyUsersJson, 200));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchUsers(page: 1, forceApi: true);

      expect(result.isLeft, false);
      expect(result.isRight, true);
      expect((result.right as List).isEmpty, true);
    });

    test(
        'Repository should return failure for failed network response with error status but valid json',
        () async {
      http.Client client = TestUtils.makeUsersClient(
          response: http.Response(TestUtils.singleUserJson, 500));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchUsers(page: 1, forceApi: true);

      expect(result.isLeft, true);
      expect(result.isRight, false);
      expect((result.left as ServerFailure).type, SOFFailureType.network);
    });

    test('Repository should return one user for responses with valid one users',
        () async {
      http.Client client = TestUtils.makeUsersClient(
          response: http.Response(TestUtils.singleUserJson, 200));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchUsers(page: 1, forceApi: true);

      expect(result.isLeft, false);
      expect(result.isRight, true);
      expect((result.right as List).length == 1, true);
    });
  });

  /// Reputations fetching
  group("Reputations list fetching", () {
    test(
        'Repository should return success with empty reputation list for success network response for fetchReputations with empty json',
        () async {
      http.Client client =
          TestUtils.makeReputationsClient(response: http.Response("{}", 201));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchReputations(userId: 22656, page: 1);

      expect(result.isLeft, false);
      expect(result.isRight, true);
      expect(result.right, []);
    });

    test(
        'Repository should return failure for success network response for fetchReputations with empty body',
        () async {
      http.Client client =
          TestUtils.makeReputationsClient(response: http.Response("", 201));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchReputations(userId: 22656, page: 1);

      expect(result.isLeft, true);
      expect(result.isRight, false);
      expect((result.left as ServerFailure).type, SOFFailureType.general);
    });

    test(
        'Repository should return failure for failed network response for fetchReputations with network errors',
        () async {
      http.Client client =
          TestUtils.makeReputationsClient(response: http.Response("", 500));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchReputations(userId: 22656, page: 1);

      expect(result.isLeft, true);
      expect(result.isRight, false);
      expect((result.left as ServerFailure).type, SOFFailureType.network);
    });

    test(
        'Repository should return success for responses with valid empty reputations',
        () async {
      http.Client client = TestUtils.makeReputationsClient(
          response: http.Response(TestUtils.emptyUsersJson, 200));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchReputations(userId: 22656, page: 1);

      expect(result.isLeft, false);
      expect(result.isRight, true);
      expect((result.right as List).isEmpty, true);
    });

    test(
        'Repository should return failure for failed network response with error status but valid json',
        () async {
      http.Client client = TestUtils.makeReputationsClient(
          response: http.Response(TestUtils.singleReputationJson, 500));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchReputations(userId: 22656, page: 1);

      expect(result.isLeft, true);
      expect(result.isRight, false);
      expect((result.left as ServerFailure).type, SOFFailureType.network);
    });

    test(
        'Repository should return one reputation for responses with valid one reputation',
        () async {
      http.Client client = TestUtils.makeReputationsClient(
          response: http.Response(TestUtils.singleReputationJson, 200));
      SOFUsersRepository repository = TestUtils.makeUserRepository(client);

      Either result = await repository.fetchReputations(userId: 22656, page: 1);

      expect(result.isLeft, false);
      expect(result.isRight, true);
      expect((result.right as List).length == 1, true);
    });
  });
}
