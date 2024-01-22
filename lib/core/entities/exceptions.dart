import '../enums/exception_enum.dart';

class ServerException implements Exception {
  final SOExceptionType? type;
  final String? message;

  ServerException({this.type, this.message});
}
