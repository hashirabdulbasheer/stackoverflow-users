import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_classes/base_usecase.dart';
import '../../../../core/models/failures.dart';
import '../entities/user.dart';
import '../repositories/bookmarks_repository.dart';

class SOFSaveBookmarksUseCase
    implements SOFBaseUseCase<bool, SaveBookmarkParams> {
  final SOFBookmarksRepository repository;

  SOFSaveBookmarksUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(SaveBookmarkParams params) {
    return Future.value(repository.saveBookmark(params.user));
  }
}

class SaveBookmarkParams extends Equatable {
  final SOFUser user;

  const SaveBookmarkParams({required this.user});

  @override
  List<Object> get props => [user];
}
