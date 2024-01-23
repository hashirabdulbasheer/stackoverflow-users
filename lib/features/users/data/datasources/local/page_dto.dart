import 'package:hive_flutter/adapters.dart';

import 'user_dto.dart';

@HiveType(typeId: 1)
class SOFPage {
  @HiveField(0)
  final int page;

  @HiveField(1)
  final List<SOFUserDto> users;

  @HiveField(2)
  final int lastUpdateTimeMs;

  SOFPage({
    required this.page,
    required this.users,
    required this.lastUpdateTimeMs,
  });
}
