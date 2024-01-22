import 'package:easy_localization/easy_localization.dart';

enum SOFExceptionType {
  network,
}

extension ParseToString on SOFExceptionType {
  String rawString() {
    return "exception.network".tr();
  }
}
