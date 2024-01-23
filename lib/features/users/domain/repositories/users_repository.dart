import 'package:either_dart/either.dart';

import '../../../../core/base_classes/base_repository.dart';
import '../../../../core/models/failures.dart';
import '../entities/reputation.dart';
import '../entities/user.dart';

abstract class SOFUsersRepository extends SOFBaseRepository {
  Future<Either<Failure, List<SOFUser>>> fetchUsers({required int page});
  Future<Either<Failure, List<SOFReputation>>> fetchReputations({required int userId, required int page});
}
