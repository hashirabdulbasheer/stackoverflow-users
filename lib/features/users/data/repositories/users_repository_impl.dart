import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:stackoverflow_users/features/users/data/datasources/local/user_dto.dart';

import '../../../../core/db/hive_manager.dart';
import '../../../../core/entities/exceptions.dart';
import '../../../../core/entities/sof_response.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/local/page_dto.dart';
import '../datasources/network/users_network_datasource.dart';

///
///  User repository implementation
///
class SOFUsersRepositoryImpl extends SOFUsersRepository {
  final SOFUsersNetworkDataSource networkDataSource;
  final SOFPagesDatabase pagesDatabase;

  SOFUsersRepositoryImpl({
    required this.networkDataSource,
    required this.pagesDatabase,
  });

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers({required int page}) async {
    try {
      /// if page is present in db then return that
      SOFPageDto? pageDto = pagesDatabase.get(page.toString());
      if (pageDto != null && pageDto.users.isNotEmpty) {
        // include cache policy checks
        print("Returning from DB $page");
        return Right(_mapPageDtoToUsers(pageDto));
      }

      /// page not found in db - fetch from api
      SOFResponse response = await networkDataSource.fetchUsers(page: page);
      if (response.isSuccessful && response.body?.isNotEmpty == true) {
        print("From API $page");
        // parse response to domain model
        List<SOFUser> users = _mapUsersResponse(response.body ?? "");
        // update db
        pagesDatabase.putUpdate(page.toString(), _mapUsersToPageDto(page, users));
        // return
        return Right(users);
      }
    } on ServerException catch (error) {
      return Left(getFailure(error));
    } catch (error) {
      print(error.toString());
    }

    return Left(getDefaultFailure());
  }

  ///
  /// Mappers
  ///
  List<SOFUser> _mapUsersResponse(String response) {
    var usersList = jsonDecode(response)['items'] as List;
    if (usersList.isNotEmpty) {
      return usersList
          .map((e) => SOFUser(
              id: e["user_id"],
              name: e["display_name"],
              avatar: Uri.parse(e["profile_image"]),
              location: e["location"] ?? "error.location_unavailable".tr(),
              reputation: e["reputation"],
              age: e["age"]))
          .toList();
    }
    return [];
  }

  List<SOFUser> _mapPageDtoToUsers(SOFPageDto pageDto) {
    var usersList = pageDto.users;
    if (usersList.isNotEmpty) {
      return usersList
          .map((e) => SOFUser(
              id: e.id,
              name: e.name,
              avatar: Uri.parse(e.avatar),
              location: e.location,
              reputation: e.reputation,
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
                avatar: e.avatar.toString(),
                location: e.location,
                reputation: e.reputation,
                age: e.age))
            .toList(),
        lastUpdateTimeMs: DateTime.now().millisecondsSinceEpoch);
  }
}
