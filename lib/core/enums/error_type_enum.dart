enum SOErrorType {
  network,
}

extension ParseToString on SOErrorType {
  String rawString() {
    return "Network Error";
  }
}
