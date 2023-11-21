import 'dart:async';

abstract class LocalStorage {
  Future<void> write(String key, dynamic value);

  FutureOr<T?> read<T>(String key);

  Future<void> remove(String key);

  Future clear();
}