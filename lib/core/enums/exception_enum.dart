enum SOExceptionEnum {
  network,
}

extension ParseToString on SOExceptionEnum {
  String rawString() {
    return "Network Error";
  }
}
