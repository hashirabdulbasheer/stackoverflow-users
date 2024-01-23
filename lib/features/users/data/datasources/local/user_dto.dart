import 'package:hive_flutter/adapters.dart';

@HiveType(typeId: 0)
class SOFUserDto {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final Uri avatar;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final int? age;

  @HiveField(5)
  final int reputation;

  const SOFUserDto(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.location,
      required this.reputation,
      this.age});
}
