import 'dart:convert';

import 'package:either_dart/either.dart';

import '../../../../core/db/hive_manager.dart';
import '../../../../core/entities/exceptions.dart';
import '../../../../core/entities/sof_response.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/reputation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/datasource.dart';
import '../datasources/local/dto/user_dto.dart';

///
///  User repository implementation
///
class SOFUsersRepositoryImpl extends SOFUsersRepository {
  final SOFUsersNetworkDataSource networkDataSource;
  final SOFUsersLocalDataSource localDataSource;
  final SOFBookmarkHiveDB bookmarksHiveDB;

  SOFUsersRepositoryImpl({
    required this.networkDataSource,
    required this.localDataSource,
    required this.bookmarksHiveDB,
  });

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers(
      {required int page, bool? forceApi}) async {
    try {
      /// Fetch bookmarked users
      List<SOFUserDto>? bookmarkedUsers = bookmarksHiveDB.getAll();

      /// if page is present in db then return that
      SOFResponse response;
      SOFResponse localResponse = await localDataSource.fetchUsers(page: page);
      // include cache policy checks later on to check cache validity
      if (!localResponse.isSuccessful || forceApi == true) {
        /// page not found in db - fetch from api
        response = await networkDataSource.fetchUsers(page: page);
      } else {
        response = localResponse;
        SOFLogger.d("DB: Page $page");
      }

      if (response.isSuccessful && response.body?.isNotEmpty == true) {
        // update local with network page
        localDataSource.saveUsersPage(
          page: page,
          responseJson: response.body ?? "",
        );
        // parse response to domain model
        List<SOFUser> users = _mapUsersResponse(
          response.body ?? "",
          bookmarkedUsers,
        );
        // return
        return Right(users);
      }
    } on ServerException catch (error) {
      return Left(getFailure(error));
    } catch (error) {
      SOFLogger.e(error);
    }

    return Left(getDefaultFailure());
  }

  @override
  Future<Either<Failure, List<SOFReputation>>> fetchReputations(
      {required int userId, required int page}) async {
    try {
      SOFResponse response =
          await networkDataSource.fetchReputation(userId: userId, page: page);
      if (response.isSuccessful && response.body?.isNotEmpty == true) {
        return Right(_mapReputationsResponse(response.body ?? ""));
      }
    } on ServerException catch (error) {
      return Left(getFailure(error));
    } catch (error) {
      SOFLogger.e(error);
    }

    return Left(getDefaultFailure());
  }

  ///
  /// Mappers
  ///

  // Users
  List<SOFUser> _mapUsersResponse(
      String response, List<SOFUserDto>? bookmarks) {
    if (jsonDecode(response)['items'] == null) {
      return [];
    }
    var usersList = jsonDecode(response)['items'] as List;
    if (usersList.isNotEmpty) {
      return usersList
          .map((e) => SOFUser(
              id: e["user_id"],
              name: e["display_name"],
              avatar: e["profile_image"],
              location: e["location"],
              reputation: e["reputation"],
              isBookmarked: _isBookmarked(e["user_id"], bookmarks),
              age: e["age"]))
          .toList();
    }
    return [];
  }

  bool _isBookmarked(int userId, List<SOFUserDto>? bookmarks) {
    try {
      SOFUserDto? user =
          bookmarks?.firstWhere((element) => element.id == userId);
      if (user != null) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  // Reputation
  List<SOFReputation> _mapReputationsResponse(String response) {
    if (jsonDecode(response)['items'] == null) {
      return [];
    }
    var reputationsList = jsonDecode(response)['items'] as List;
    if (reputationsList.isNotEmpty) {
      return reputationsList
          .map((e) => SOFReputation(
                type: e["reputation_history_type"],
                change: e["reputation_change"],
                createdAt: e["creation_date"],
                postId: e["post_id"],
              ))
          .toList();
    }
    return [];
  }
}
