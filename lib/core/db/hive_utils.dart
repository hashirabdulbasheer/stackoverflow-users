import 'package:hive_flutter/hive_flutter.dart';

import '../../features/users/data/datasources/local/page_dto.dart';
import '../../features/users/data/datasources/local/user_dto.dart';

/// Open all hive boxes here
class SOFHiveBoxes {
  static Future<void> open() async {
    await Hive.openBox('sof_pages_box');
    await Hive.openBox('sof_bookmarks_box');
  }
}

/// Registration of hive database adapters
class SOFHiveAdapters {
  static Future<void> register() async {
    Hive.registerAdapter(SOFPageDtoAdapter());
    Hive.registerAdapter(SOFUserDtoAdapter());
  }
}
