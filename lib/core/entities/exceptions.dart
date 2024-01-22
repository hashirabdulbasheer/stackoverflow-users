import '../enums/error_type_enum.dart';
///
/// Errors in data source layer
///
class ServerException implements Exception {
  final SOErrorType? type;
  final String? message;

  ServerException({this.type, this.message});
}
