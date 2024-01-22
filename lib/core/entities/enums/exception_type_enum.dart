import 'package:easy_localization/easy_localization.dart';

enum SOExceptionType {
  network,
}

extension ParseToString on SOExceptionType {
  String rawString() {
    return "exception.network".tr();
  }
}
