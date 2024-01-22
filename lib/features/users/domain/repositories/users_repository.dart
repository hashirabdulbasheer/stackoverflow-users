import 'package:either_dart/either.dart';

import '../../../../core/base_classes/base_repository.dart';
import '../../../../core/models/failures.dart';
import '../entities/user.dart';

abstract class SOUsersRepository extends BaseRepository {
  Future<Either<Failure, List<SOFUser>>> fetchUsers();
}
