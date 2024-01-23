import 'package:either_dart/either.dart';
import 'package:stackoverflow_users/features/users/data/datasources/local/user_dto.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/bookmarks_repository.dart';

import '../../../../core/db/hive_manager.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/user.dart';
import '../datasources/network/users_network_datasource.dart';

///
///  User repository implementation
///
class SOFBookmarksRepositoryImpl extends SOFBookmarksRepository {
  final SOFUsersNetworkDataSource networkDataSource;
  final SOFUsersBookmarkDataSource bookmarkDataSource;

  SOFBookmarksRepositoryImpl({
    required this.networkDataSource,
    required this.bookmarkDataSource,
  });

  @override
  Either<Failure, List<SOFUser>> fetchBookmarks() {
    try {
      List<SOFUserDto>? bookmarkedUsers = bookmarkDataSource.getAll();
      if (bookmarkedUsers == null) {
        return const Right([]);
      }

      return Right(_mapUsersDtoToUsers(bookmarkedUsers));
    } catch (error) {
      print(error.toString());
    }

    return Left(getDefaultFailure());
  }

  @override
  Either<Failure, bool> saveBookmark(SOFUser user) {
    try {
      SOFUserDto userDto = _mapUserToUserDto(user);
      bookmarkDataSource.putUpdate(user.id.toString(), userDto);

      return const Right(true);
    } catch (error) {
      print(error.toString());
    }

    return Left(getDefaultFailure());
  }

  @override
  Either<Failure, bool> deleteBookmark(SOFUser user) {
    try {
      bookmarkDataSource.delete(user.id.toString());

      return const Right(true);
    } catch (error) {
      print(error.toString());
    }

    return Left(getDefaultFailure());
  }

  ///
  /// Mappers
  ///

  List<SOFUser> _mapUsersDtoToUsers(List<SOFUserDto> userDto) {
    if (userDto.isNotEmpty) {
      return userDto
          .map((e) => SOFUser(
              id: e.id,
              name: e.name,
              avatar: e.avatar,
              location: e.location,
              reputation: e.reputation,
              age: e.age))
          .toList();
    }
    return [];
  }

  SOFUserDto _mapUserToUserDto(SOFUser user) {
    return SOFUserDto(
        id: user.id,
        name: user.name,
        avatar: user.avatar,
        location: user.location,
        reputation: user.reputation,
        age: user.age);
  }
}
