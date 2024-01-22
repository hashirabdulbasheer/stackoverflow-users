enum SOExceptionType {
  network,
}

extension ParseToString on SOExceptionType {
  String rawString() {
    return "Network Error";
  }
}
