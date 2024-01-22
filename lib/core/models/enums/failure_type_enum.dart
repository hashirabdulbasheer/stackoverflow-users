enum SOFailureType { general, network }

extension ParseToString on SOFailureType {
  String rawString() {
    switch (this) {
      case SOFailureType.general:
        return "General Failure";
      case SOFailureType.network:
        return "Network Failure";
      default:
        return "Failure";
    }
  }
}
