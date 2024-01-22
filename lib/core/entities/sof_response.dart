///
/// SOResponse
///   - entity for response of datasource
///
import 'package:equatable/equatable.dart';

class SOFResponse extends Equatable {
  final bool isSuccessful;
  final String? body;

  const SOFResponse({required this.isSuccessful, this.body});

  @override
  List<Object?> get props => [isSuccessful, body];
}
