import 'dart:async';

import 'package:memory_cache/memory_cache.dart';

extension MemoryCacheUtil on MemoryCache {
  Future<T> get<T>({
    required String key,
    required FutureOr<T> Function() fallback,
    Duration duration = const Duration(minutes: 5),
  }) async {
    if (contains(key)) return read(key);
    var result = await fallback();
    create(key, result, expiry: duration);
    return result;
  }
}