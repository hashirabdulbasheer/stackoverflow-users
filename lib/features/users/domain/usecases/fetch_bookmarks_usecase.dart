import 'package:either_dart/either.dart';

import '../../../../core/base_classes/base_usecase.dart';
import '../../../../core/models/failures.dart';
import '../entities/user.dart';
import '../repositories/bookmarks_repository.dart';

class SOFFetchBookmarksUseCase
    implements SOFBaseUseCase<List<SOFUser>, NoParams> {
  final SOFBookmarksRepository repository;

  SOFFetchBookmarksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SOFUser>>> call(NoParams params) {
    return Future.value(repository.fetchBookmarks());
  }
}
