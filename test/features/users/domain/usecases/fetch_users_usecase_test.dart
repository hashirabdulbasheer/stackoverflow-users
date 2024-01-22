import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:stackoverflow_users/core/misc/di_container.dart';
import 'package:stackoverflow_users/core/models/enums/failure_type_enum.dart';
import 'package:stackoverflow_users/core/models/failures.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/fetch_users_usecase.dart';

import '../../../../utils/test_utils.dart';

void main() {
  setUp(() async {});

  tearDown(() async {
    await sl.reset(dispose: false);
  });

  test(
      'UseCase should return failure for success network response for fetchUsers with empty json',
      () async {
    await SOFDiContainer.init(
        networkClient:
            TestUtils.makeUsersClient(response: http.Response("{}", 200)));
    SOFFetchUsersUseCase useCase = sl<SOFFetchUsersUseCase>();

    Either result = await useCase.call(const FetchUsersListParams(page: 1));

    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.general);
  });

  test(
      'UseCase should return failure for success network response for fetchUsers with empty body',
      () async {
    await SOFDiContainer.init(
        networkClient:
            TestUtils.makeUsersClient(response: http.Response("", 200)));
    SOFFetchUsersUseCase useCase = sl<SOFFetchUsersUseCase>();

    Either result = await useCase.call(const FetchUsersListParams(page: 1));
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.general);
  });

  test(
      'UseCase should return failure for failed network response for fetchUsers with network errors',
      () async {
    await SOFDiContainer.init(
        networkClient:
            TestUtils.makeUsersClient(response: http.Response("", 500)));
    SOFFetchUsersUseCase useCase = sl<SOFFetchUsersUseCase>();

    Either result = await useCase.call(const FetchUsersListParams(page: 1));
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.network);
  });

  test('UseCase should return success for responses with valid empty users',
      () async {
    await SOFDiContainer.init(
        networkClient: TestUtils.makeUsersClient(
            response: http.Response(TestUtils.emptyUsersJson, 200)));
    SOFFetchUsersUseCase useCase = sl<SOFFetchUsersUseCase>();

    Either result = await useCase.call(const FetchUsersListParams(page: 1));
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect((result.right as List).isEmpty, true);
  });

  test(
      'UseCase should return failure for failed network response with error status but valid json',
      () async {
    await SOFDiContainer.init(
        networkClient: TestUtils.makeUsersClient(
            response: http.Response(TestUtils.singleUserJson, 500)));
    SOFFetchUsersUseCase useCase = sl<SOFFetchUsersUseCase>();

    Either result = await useCase.call(const FetchUsersListParams(page: 1));
    expect(result.isLeft, true);
    expect(result.isRight, false);
    expect((result.left as ServerFailure).type, SOFFailureType.network);
  });

  test('UseCase should return one user for responses with valid one users',
      () async {
    await SOFDiContainer.init(
        networkClient: TestUtils.makeUsersClient(
            response: http.Response(TestUtils.singleUserJson, 200)));
    SOFFetchUsersUseCase useCase = sl<SOFFetchUsersUseCase>();

    Either result = await useCase.call(const FetchUsersListParams(page: 1));
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect((result.right as List).length == 1, true);
  });
}
