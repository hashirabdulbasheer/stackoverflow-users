import 'dart:convert';

import 'package:either_dart/either.dart';

import '../../../../core/entities/sof_response.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../datasources/datasource.dart';

///
///  User repository implementation
///
class SOFBookmarksRepositoryImpl extends SOFBookmarksRepository {
  final SOFBookmarksLocalDataSource bookmarkDataSource;

  SOFBookmarksRepositoryImpl({required this.bookmarkDataSource});

  @override
  Future<Either<Failure, List<SOFUser>>> fetchBookmarks() async {
    try {
      SOFResponse response = await bookmarkDataSource.fetchBookmarks();
      if (!response.isSuccessful) {
        return const Right([]);
      }

      return Right(_mapResponseToUsers(response.body ?? ""));
    } catch (error) {
      SOFLogger.e(error);
    }

    return Left(getDefaultFailure());
  }

  @override
  Future<Either<Failure, bool>> saveBookmark(SOFUser user) async {
    SOFResponse response =
        await bookmarkDataSource.saveBookmark(_mapUserToUserJson(user));
    if (response.isSuccessful) {
      return const Right(true);
    }

    return Left(getDefaultFailure());
  }

  @override
  Future<Either<Failure, bool>> deleteBookmark(SOFUser user) async {
    SOFResponse response =
        await bookmarkDataSource.deleteBookmark(_mapUserToUserJson(user));
    if (response.isSuccessful) {
      return const Right(true);
    }

    return Left(getDefaultFailure());
  }

  ///
  /// Mappers
  ///

  List<SOFUser> _mapResponseToUsers(String response) {
    if (jsonDecode(response)['items'] != null) {
      var usersList = jsonDecode(response)['items'] as List;
      if (usersList.isNotEmpty) {
        return usersList
            .map((e) => SOFUser(
                id: e["user_id"],
                name: e["display_name"],
                avatar: e["profile_image"],
                location: e["location"],
                reputation: e["reputation"],
                isBookmarked: true,
                age: e["age"]))
            .toList();
      }
    }
    return [];
  }

  String _mapUserToUserJson(SOFUser user) {
    Map<String, dynamic> userMap = {};
    userMap["user_id"] = user.id;
    userMap["display_name"] = user.name;
    userMap["profile_image"] = user.avatar;
    userMap["location"] = user.location;
    userMap["reputation"] = user.reputation;
    userMap["age"] = user.age;

    return jsonEncode(userMap);
  }
}
