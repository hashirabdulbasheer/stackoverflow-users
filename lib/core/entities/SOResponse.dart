///
/// SOResponse
///   - entity for response of datasource
///
import 'package:equatable/equatable.dart';

class SOResponse extends Equatable {
  final bool isSuccessful;
  final String? body;

  const SOResponse({required this.isSuccessful, this.body});

  @override
  List<Object?> get props => [isSuccessful, body];
}
