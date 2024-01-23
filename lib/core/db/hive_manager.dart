import 'package:hive_flutter/hive_flutter.dart';

abstract class SOFDatabase {
  final String databaseName;

  SOFDatabase(this.databaseName);

  Box get box;

  T? get<T>(String key);

  T? getAtIndex<T>(int index);

  List<T>? getAll<T>();

  Future delete(String key);

  Future deleteAll(List<String> keys);

  Future deleteAtIndex(int index);

  Future putUpdate<T>(String key, T item);

  Future putAtIndex<T>(int index, T item);

  Future addUpdate<T>(T item);

  Future clearTheBox();
}

class SOFDatabaseImpl extends SOFDatabase {
  SOFDatabaseImpl(String databaseName) : super(databaseName);

  @override
  Future putUpdate<T>(String key, T item) async {
    try {
      await box.put(key, item);
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future putAtIndex<T>(int index, T item) async {
    try {
      await box.putAt(index, item);
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future delete(String key) async {
    try {
      await box.delete(key);
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future deleteAll(List<String> keys) async {
    try {
      await box.deleteAll(keys);
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future deleteAtIndex(int index) async {
    try {
      await box.deleteAt(index);
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  T? getAtIndex<T>(int index) {
    try {
      final data = box.getAt(index);
      return data;
    } catch (_) {}
    return null;
  }

  @override
  T? get<T>(String key) {
    try {
      final data = box.get(key);
      return data;
    } catch (_) {}
    return null;
  }

  @override
  List<T>? getAll<T>() {
    try {
      final data = box.toMap().values;
      return data.toList().cast<T>();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future addUpdate<T>(T item) async {
    try {
      await box.add(item);
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future clearTheBox() async {
    try {
      await box.clear();
      await box.flush();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Box get box => Hive.box(databaseName);
}

class SOFUsersLocalDataSource extends SOFDatabaseImpl {
  SOFUsersLocalDataSource() : super('sof_pages_box');
}

class SOFUsersBookmarkDataSource extends SOFDatabaseImpl {
  SOFUsersBookmarkDataSource() : super('sof_bookmarks_box');
}
