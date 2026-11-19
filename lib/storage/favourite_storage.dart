import 'dart:convert';

import 'package:product_app/core/local_storage/local_storage_key.dart';
import 'package:product_app/core/local_storage/local_storage_service.dart';
import 'package:product_app/data/model/products_response/products_response.dart';

class FavouriteStorage {
  FavouriteStorage(this._storage);

  final LocalStorageService _storage;

  List<Product> read() {
    final raw = _storage.read(LocalStorageKeys.favourites);
    if (raw == null) return const [];
    try {
      return [
        for (final item in jsonDecode(raw) as List)
          Product.fromJson(item as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<void> write(List<Product> products) => _storage.write(
    LocalStorageKeys.favourites,
    jsonEncode([for (final p in products) p.toJson()]),
  );
}