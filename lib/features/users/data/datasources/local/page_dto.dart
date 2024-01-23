import 'package:hive_flutter/hive_flutter.dart';

import 'user_dto.dart';

part 'page_dto.g.dart';

@HiveType(typeId: 1)
class SOFPageDto {
  @HiveField(0)
  final int page;

  @HiveField(1)
  final List<SOFUserDto> users;

  @HiveField(2)
  final int lastUpdateTimeMs;

  SOFPageDto({
    required this.page,
    required this.users,
    required this.lastUpdateTimeMs,
  });
}
