import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_classes/base_usecase.dart';
import '../../../../core/models/failures.dart';
import '../entities/user.dart';
import '../repositories/bookmarks_repository.dart';

class SOFDeleteBookmarksUseCase
    implements SOFBaseUseCase<bool, DeleteBookmarkParams> {
  final SOFBookmarksRepository repository;

  SOFDeleteBookmarksUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(DeleteBookmarkParams params) {
    return Future.value(repository.deleteBookmark(params.user));
  }
}

class DeleteBookmarkParams extends Equatable {
  final SOFUser user;

  const DeleteBookmarkParams({required this.user});

  @override
  List<Object> get props => [user];
}
