import 'package:equatable/equatable.dart';

/// SOF User domain entity
class SOFUser extends Equatable {
  final int id;
  final String name;
  final String avatar;
  final String location;
  final int? age;
  final int reputation;

  const SOFUser(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.location,
      required this.reputation,
      this.age});

  SOFUser copyWith(
      {int? id,
      String? name,
      String? avatar,
      String? location,
      int? age,
      int? reputation}) {
    return SOFUser(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        location: location ?? this.location,
        age: age ?? this.age,
        reputation: reputation ?? this.reputation);
  }

  @override
  List<Object?> get props => [id, name, avatar, location, age, reputation];
}
