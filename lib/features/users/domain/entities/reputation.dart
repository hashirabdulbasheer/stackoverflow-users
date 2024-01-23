import 'package:equatable/equatable.dart';

class SOFReputation extends Equatable {
  final String type;
  final int change;
  final int createdAt;
  final int postId;

  const SOFReputation({
    required this.type,
    required this.change,
    required this.createdAt,
    required this.postId,
  });

  SOFReputation copyWith({
    String? type,
    int? change,
    int? createdAt,
    int? postId,
  }) {
    return SOFReputation(
        type: type ?? this.type,
        change: change ?? this.change,
        createdAt: createdAt ?? this.createdAt,
        postId: postId ?? this.postId);
  }

  @override
  List<Object?> get props => [
        type,
        change,
        createdAt,
        postId,
      ];
}
