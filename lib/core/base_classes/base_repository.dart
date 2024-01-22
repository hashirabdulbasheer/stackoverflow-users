import '../entities/exceptions.dart';
import '../models/enums/failure_type_enum.dart';
import '../models/failures.dart';

abstract class BaseRepository {
  Failure getFailure(Object e) {
    if (e is ServerException) {
      return ServerFailure(type: SOFailureType.network, message: e.message);
    }
    return getDefaultFailure();
  }

  Failure getFailureWithMessage(String message) {
    return ServerFailure(type: SOFailureType.general, message: message);
  }

  Failure getDefaultFailure() {
    return ServerFailure(
        type: SOFailureType.general, message: "Some error occurred");
  }
}
