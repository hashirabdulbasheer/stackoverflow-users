///
/// SOResponse
///   - entity for response of datasource
///
import 'package:equatable/equatable.dart';

class SOResponse extends Equatable {
  final bool isSuccessful;
  final String? body;
  final int? statusCode;

  const SOResponse({required this.isSuccessful, this.body, this.statusCode});

  @override
  List<Object?> get props => [isSuccessful, body, statusCode];
}
