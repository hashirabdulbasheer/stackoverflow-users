import '../entities/exceptions.dart';
import '../models/enums/failure_type_enum.dart';
import '../models/failures.dart';

abstract class SOFBaseRepository {
  Failure getFailure(Object e) {
    if (e is ServerException) {
      return ServerFailure(type: SOFFailureType.network, message: e.message);
    }
    return getDefaultFailure();
  }

  Failure getFailureWithMessage(String message) {
    return ServerFailure(type: SOFFailureType.general, message: message);
  }

  Failure getDefaultFailure() {
    return ServerFailure(
        type: SOFFailureType.general, message: "Some error occurred");
  }
}
