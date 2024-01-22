import 'package:easy_localization/easy_localization.dart';

enum SOFailureType { general, network }

extension ParseToString on SOFailureType {
  String rawString() {
    switch (this) {
      case SOFailureType.general:
        return "failure.general".tr();
      case SOFailureType.network:
        return "failure.network".tr();
      default:
        return "failure.default".tr();
    }
  }
}
