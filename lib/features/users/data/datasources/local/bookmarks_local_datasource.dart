import 'dart:convert';

import '../../../../../core/db/hive_manager.dart';
import '../../../../../core/entities/sof_response.dart';
import '../../../../../core/misc/logger.dart';
import '../datasource.dart';
import 'dto/user_dto.dart';

class SOFBookmarksLocalDataSourceImpl implements SOFBookmarksLocalDataSource {
  final SOFBookmarkHiveDB database;

  SOFBookmarksLocalDataSourceImpl({required this.database});

  @override
  Future<SOFResponse> deleteBookmark(String userJson) {
    try {
      SOFUserDto? userDto = _mapUserJsonToUserDto(userJson);
      if (userDto != null) {
        database.delete(userDto.id.toString());
        return Future.value(
            const SOFResponse(isSuccessful: true, body: "success"));
      }
    } catch (error) {
      SOFLogger.e(error);
    }

    return Future.value(const SOFResponse(isSuccessful: false, body: null));
  }

  @override
  Future<SOFResponse> fetchBookmarks() {
    List<SOFUserDto>? bookmarkedUsers = database.getAll();
    if (bookmarkedUsers != null) {
      return Future.value(SOFResponse(
        isSuccessful: true,
        body: _mapUsersDtoToUsersJsonString(bookmarkedUsers),
      ));
    }

    return Future.value(const SOFResponse(isSuccessful: false, body: null));
  }

  @override
  Future<SOFResponse> saveBookmark(String userJson) {
    try {
      SOFUserDto? userDto = _mapUserJsonToUserDto(userJson);
      if (userDto != null) {
        database.putUpdate(userDto.id.toString(), userDto);
        return Future.value(
            const SOFResponse(isSuccessful: true, body: "success"));
      }
    } catch (error) {
      SOFLogger.e(error);
    }

    return Future.value(const SOFResponse(isSuccessful: false, body: null));
  }

  /// Mappers

  SOFUserDto? _mapUserJsonToUserDto(String userJson) {
    var user = jsonDecode(userJson);
    if (user != null) {
      return SOFUserDto(
          id: user["user_id"],
          name: user["display_name"],
          avatar: user["profile_image"],
          location: user["location"],
          reputation: user["reputation"],
          age: user["age"]);
    }

    return null;
  }

  String _mapUsersDtoToUsersJsonString(List<SOFUserDto> users) {
    Map<String, dynamic> jsonMap = {};
    List<dynamic> usersList = [];
    for (SOFUserDto user in users) {
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
