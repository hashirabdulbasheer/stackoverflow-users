import 'package:equatable/equatable.dart';

import '../enums/error_type_enum.dart';

///
/// Errors in domain layer
///

abstract class Failure {}

class GeneralFailure extends Failure with EquatableMixin {
  final String message;

  GeneralFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends GeneralFailure {
  final SOErrorType type;

  ServerFailure({required this.type, message}) : super(message: message);

  @override
  List<Object> get props => [type, message];
}
