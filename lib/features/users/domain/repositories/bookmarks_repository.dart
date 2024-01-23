import 'package:either_dart/either.dart';

import '../../../../core/base_classes/base_repository.dart';
import '../../../../core/models/failures.dart';
import '../entities/user.dart';

abstract class SOFBookmarksRepository extends SOFBaseRepository {
  Either<Failure, List<SOFUser>> fetchBookmarks();
  Either<Failure, bool> saveBookmark(SOFUser user);
  Either<Failure, bool> deleteBookmark(SOFUser user);
}
