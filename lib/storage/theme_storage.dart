import 'package:flutter/material.dart';
import 'package:product_app/core/local_storage/local_storage_key.dart';
import 'package:product_app/core/local_storage/local_storage_service.dart';

class ThemeStorage {
  ThemeStorage(this._storage);

  final LocalStorageService _storage;

  ThemeMode read() {
    final value = _storage.read(LocalStorageKeys.themeMode);
    return ThemeMode.values.asNameMap()[value] ?? ThemeMode.system;
  }

  Future<void> write(ThemeMode mode) =>
      _storage.write(LocalStorageKeys.themeMode, mode.name);
}