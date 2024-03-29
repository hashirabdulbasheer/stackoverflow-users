import 'enums/exception_type_enum.dart';

///
/// Errors in data source layer
///
class ServerException implements Exception {
  final SOFExceptionType? type;
  final String? message;

  ServerException({this.type, this.message});
}
