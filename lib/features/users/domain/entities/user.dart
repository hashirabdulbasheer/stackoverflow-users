import 'package:equatable/equatable.dart';

/// SOF User domain entity
class SOFUser extends Equatable {
  final String name;
  final Uri avatar;
  final String location;
  final int? age;

  const SOFUser(
      {required this.name,
      required this.avatar,
      required this.location,
      this.age});

  SOFUser copyWith({String? name, Uri? avatar, String? location, int? age}) {
    return SOFUser(
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        location: location ?? this.location,
        age: age ?? this.age);
  }

  @override
  List<Object?> get props => [name, avatar, location, age];
}
