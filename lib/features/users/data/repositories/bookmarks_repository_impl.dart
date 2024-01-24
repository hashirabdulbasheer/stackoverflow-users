import 'package:either_dart/either.dart';

import '../../../../core/db/hive_manager.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../datasources/datasource.dart';
import '../datasources/local/dto/user_dto.dart';

///
///  User repository implementation
///
class SOFBookmarksRepositoryImpl extends SOFBookmarksRepository {
  final SOFUsersDataSource networkDataSource;
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
      SOFLogger.e(error);
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
      SOFLogger.e(error);
    }

    return Left(getDefaultFailure());
  }

  @override
  Either<Failure, bool> deleteBookmark(SOFUser user) {
    try {
      bookmarkDataSource.delete(user.id.toString());

      return const Right(true);
    } catch (error) {
      SOFLogger.e(error);
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
              isBookmarked: false,
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
