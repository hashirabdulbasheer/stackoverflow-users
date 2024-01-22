import 'package:easy_localization/easy_localization.dart';

enum SOFFailureType { general, network }

extension ParseToString on SOFFailureType {
  String rawString() {
    switch (this) {
      case SOFFailureType.general:
        return "failure.general".tr();
      case SOFFailureType.network:
        return "failure.network".tr();
      default:
        return "failure.default".tr();
    }
  }
}
