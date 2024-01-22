import 'package:either_dart/either.dart';

import '../models/failures.dart';

abstract class SOFBaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
