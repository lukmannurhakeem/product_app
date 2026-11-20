import 'dart:convert';

import 'package:product_app/core/local_storage/local_storage_key.dart';
import 'package:product_app/core/local_storage/local_storage_service.dart';

class RecentSearchStorage {
  RecentSearchStorage(this._storage);

  final LocalStorageService _storage;

  List<String> read() {
    final raw = _storage.read(LocalStorageKeys.recentSearches);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List).whereType<String>().toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> write(List<String> queries) =>
      _storage.write(LocalStorageKeys.recentSearches, jsonEncode(queries));
}