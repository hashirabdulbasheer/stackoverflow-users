import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';

import '../../../../core/db/hive_manager.dart';
import '../../../../core/entities/exceptions.dart';
import '../../../../core/entities/sof_response.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/reputation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/local/page_dto.dart';
import '../datasources/local/user_dto.dart';
import '../datasources/network/users_network_datasource.dart';

///
///  User repository implementation
///
class SOFUsersRepositoryImpl extends SOFUsersRepository {
  final SOFUsersNetworkDataSource networkDataSource;
  final SOFUsersLocalDataSource localDataSource;
  final SOFUsersBookmarkDataSource bookmarkDataSource;

  SOFUsersRepositoryImpl({
    required this.networkDataSource,
    required this.localDataSource,
    required this.bookmarkDataSource,
  });

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers({required int page, bool? forceLoadFromApi}) async {
    try {
      /// Fetch bookmarked users
      List<SOFUserDto>? bookmarkedUsers = bookmarkDataSource.getAll();

      /// if page is present in db then return that
      SOFPageDto? pageDto = localDataSource.get(page.toString());
      if (pageDto != null && pageDto.users.isNotEmpty && forceLoadFromApi != true) {
        // include cache policy checks later on
        SOFLogger.d("DB: Page $page");
        return Right(_mapPageDtoToUsers(pageDto, bookmarkedUsers));
      }

      /// page not found in db - fetch from api
      SOFResponse response = await networkDataSource.fetchUsers(page: page);
      if (response.isSuccessful && response.body?.isNotEmpty == true) {
        // parse response to domain model
        List<SOFUser> users =
            _mapUsersResponse(response.body ?? "", bookmarkedUsers);
        // update db
        localDataSource.putUpdate(
            page.toString(), _mapUsersToPageDto(page, users));
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
    var usersList = jsonDecode(response)['items'] as List;
    if (usersList.isNotEmpty) {
      return usersList
          .map((e) => SOFUser(
              id: e["user_id"],
              name: e["display_name"],
              avatar: e["profile_image"],
              location: e["location"] ?? "error.location_unavailable".tr(),
              reputation: e["reputation"],
              isBookmarked: _isBookmarked(e["user_id"], bookmarks),
              age: e["age"]))
          .toList();
    }
    return [];
  }

  List<SOFUser> _mapPageDtoToUsers(
      SOFPageDto pageDto, List<SOFUserDto>? bookmarks) {
    var usersList = pageDto.users;
    if (usersList.isNotEmpty) {
      return usersList
          .map((e) => SOFUser(
              id: e.id,
              name: e.name,
              avatar: e.avatar,
              location: e.location,
              reputation: e.reputation,
              isBookmarked: _isBookmarked(e.id, bookmarks),
              age: e.age))
          .toList();
    }
    return [];
  }

  SOFPageDto _mapUsersToPageDto(int page, List<SOFUser> users) {
    return SOFPageDto(
        page: page,
        users: users
            .map((e) => SOFUserDto(
                id: e.id,
                name: e.name,
                avatar: e.avatar,
                location: e.location,
                reputation: e.reputation,
                age: e.age))
            .toList(),
        lastUpdateTimeMs: DateTime.now().millisecondsSinceEpoch);
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
