import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:stackoverflow_users/core/configs/network_config.dart';
import 'package:stackoverflow_users/core/entities/sof_response.dart';
import 'package:stackoverflow_users/features/users/data/datasources/datasource.dart';
import 'package:stackoverflow_users/features/users/data/datasources/network/users_network_datasource.dart';
import 'package:stackoverflow_users/features/users/data/repositories/bookmarks_repository_impl.dart';
import 'package:stackoverflow_users/features/users/data/repositories/users_repository_impl.dart';
import 'package:stackoverflow_users/features/users/domain/entities/reputation.dart';
import 'package:stackoverflow_users/features/users/domain/entities/user.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/bookmarks_repository.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/users_repository.dart';

import '../features/users/data/datasources/users_network_datasource_test.mocks.dart';

/// Shared utility methods that can be accessed across test cases

class TestUtils {
  static SOFUser user = const SOFUser(
      id: 22656,
      name: "JonSkeet",
      avatar:
          "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG",
      location: "Reading,UnitedKingdom",
      age: null,
      reputation: 1444575,
      isBookmarked: true);

  static SOFReputation reputation = const SOFReputation(
      type: "post_upvoted", change: 0, createdAt: 1706033406, postId: 7580347);

  static SOFUsersRepository makeUserRepository(http.Client client) {
    SOFUsersNetworkDataSource networkDataSource =
        SOFUsersNetworkDataSourceImpl(client: client);
    SOFUsersLocalDataSource localDataSource = MockLocalDataSource(isUserAvailable: true);
    SOFBookmarksLocalDataSource bookmarksDataSource = MockBookmarkDataSource();
    return SOFUsersRepositoryImpl(
        networkDataSource: networkDataSource,
        localDataSource: localDataSource,
        localBookmarksDataSource: bookmarksDataSource);
  }

  static SOFUsersRepository makeUserRepositoryWithNoUsers(http.Client client) {
    SOFUsersNetworkDataSource networkDataSource =
    SOFUsersNetworkDataSourceImpl(client: client);
    SOFUsersLocalDataSource localDataSource = MockLocalDataSource(isUserAvailable: false);
    SOFBookmarksLocalDataSource bookmarksDataSource = MockBookmarkDataSource();
    return SOFUsersRepositoryImpl(
        networkDataSource: networkDataSource,
        localDataSource: localDataSource,
        localBookmarksDataSource: bookmarksDataSource);
  }

  static SOFBookmarksRepository makeBookmarksRepository(http.Client client) {
    SOFBookmarksLocalDataSource bookmarksDataSource = MockBookmarkDataSource();
    return SOFBookmarksRepositoryImpl(bookmarkDataSource: bookmarksDataSource);
  }

  static MockClient makeUsersClient({required http.Response response}) {
    final headersToPass = <String, String>{};
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

  static MockClient makeReputationsClient({required http.Response response}) {
    final headersToPass = <String, String>{};
    headersToPass.addAll(<String, String>{
      "Accept": "application/json;charset=utf-t",
      "Accept-Language": "en",
    });
    final client = MockClient();
    when(client.get(
            Uri.parse(
                "https://${SOFNetworkConfig.usersBaseUrl}/${SOFNetworkConfig.apiVersion}/users/22656/reputation-history?page=1&pagesize=${SOFNetworkConfig.pageSize}&site=stackoverflow"),
            headers: headersToPass))
        .thenAnswer((_) async => response);

    return client;
  }

  static const String errorJson =
      '{"error_id": 403, "error_message": "someError", "error_name": "network_error"}';

  static const String emptyUsersJson = '{ "items": []}';
  static const String singleUserJson =
      '{ "items": [{"badge_counts":{"bronze":9231,"silver":9183,"gold":873},"account_id":11683,"is_employee":false,"last_modified_date":1704297305,"last_access_date":1705927755,"reputation_change_year":3517,"reputation_change_quarter":3517,"reputation_change_month":3517,"reputation_change_week":196,"reputation_change_day":130,"reputation":1444575,"creation_date":1222430705,"user_type":"registered","user_id":22656,"accept_rate":86,"location":"Reading,UnitedKingdom","website_url":"http://csharpindepth.com","link":"https://stackoverflow.com/users/22656/jon-skeet","profile_image":"https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG","display_name":"JonSkeet"}]}';

  static const String singleReputationJson =
      '{ "items": [{"reputation_history_type": "post_upvoted","reputation_change": 0,"post_id": 7580347,"creation_date": 1706033406,"user_id": 22656}]}';
}

class MockLocalDataSource implements SOFUsersLocalDataSource {
  bool isUserAvailable = true;

  MockLocalDataSource({required this.isUserAvailable});

  @override
  Future<SOFResponse> fetchUsers({required int page}) {
    if (isUserAvailable) {
      return Future.value(const SOFResponse(
          isSuccessful: true, body: TestUtils.singleUserJson));
    }
    return Future.value(const SOFResponse(isSuccessful: true, body: ""));
  }

  @override
  Future<bool> saveUsersPage(
      {required int page, required String responseJson}) {
    return Future.value(true);
  }
}

class MockBookmarkDataSource implements SOFBookmarksLocalDataSource {
  @override
  Future<SOFResponse> deleteBookmark(String userJson) {
    return Future.value(const SOFResponse(isSuccessful: true, body: "success"));
  }

  @override
  Future<SOFResponse> fetchBookmarks() {
    return Future.value(
        const SOFResponse(isSuccessful: true, body: TestUtils.singleUserJson));
  }

  @override
  Future<SOFResponse> saveBookmark(String userJson) {
    return Future.value(const SOFResponse(isSuccessful: true, body: "success"));
  }
}
