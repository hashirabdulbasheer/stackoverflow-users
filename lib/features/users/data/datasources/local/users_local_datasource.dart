import 'dart:convert';

import '../../../../../core/db/hive_manager.dart';
import '../../../../../core/entities/sof_response.dart';
import '../datasource.dart';
import 'dto/page_dto.dart';
import 'dto/user_dto.dart';

class SOFUsersLocalDataSourceImpl implements SOFUsersLocalDataSource {
  final SOFUsersHiveDB database;

  SOFUsersLocalDataSourceImpl({required this.database});

  @override
  Future<SOFResponse> fetchUsers({required int page}) {
    SOFPageDto? pageDto = database.get(page.toString());
    if (pageDto != null) {
      return Future.value(SOFResponse(
          isSuccessful: true, body: _mapPageDtoToUsersJsonString(pageDto)));
    }

    return Future.value(const SOFResponse(isSuccessful: false, body: null));
  }

  @override
  Future<bool> saveUsersPage(
      {required int page, required String responseJson}) {
    if (responseJson.isNotEmpty) {
      database.putUpdate(
          page.toString(), _mapPageDtoResponse(page, responseJson));

      return Future.value(true);
    }

    return Future.value(false);
  }

  /// Mappers
  SOFPageDto _mapPageDtoResponse(int page, String response) {
    if (jsonDecode(response)['items'] != null) {
      var usersList = jsonDecode(response)['items'] as List;
      if (usersList.isNotEmpty) {
        return SOFPageDto(
            page: page,
            users: usersList
                .map((e) => SOFUserDto(
                    id: e["user_id"],
                    name: e["display_name"],
                    avatar: e["profile_image"],
                    location: e["location"],
                    reputation: e["reputation"],
                    age: e["age"]))
                .toList(),
            lastUpdateTimeMs: DateTime.now().millisecondsSinceEpoch);
      }
    }

    return SOFPageDto(
        page: page,
        users: [],
        lastUpdateTimeMs: DateTime.now().millisecondsSinceEpoch);
  }

  String _mapPageDtoToUsersJsonString(SOFPageDto pageDto) {
    Map<String, dynamic> jsonMap = {};
    List<dynamic> usersList = [];
    for (SOFUserDto user in pageDto.users) {
      Map<String, dynamic> userMap = {};
      userMap["user_id"] = user.id;
      userMap["display_name"] = user.name;
      userMap["profile_image"] = user.avatar;
      userMap["location"] = user.location;
      userMap["reputation"] = user.reputation;
      userMap["age"] = user.age;

      usersList.add(userMap);
    }
    jsonMap["items"] = usersList;

    return jsonEncode(jsonMap);
  }
}
