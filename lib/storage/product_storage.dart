import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:product_app/core/local_storage/local_storage_key.dart';
import 'package:product_app/core/local_storage/local_storage_service.dart';
import 'package:product_app/data/model/products_response/products_response.dart';

class ProductStorage {
  ProductStorage(this._storage);

  final LocalStorageService _storage;

  ProductsResponse? read() {
    final raw = _storage.read(LocalStorageKeys.products);
    if (raw == null) return null;
    try {
      return ProductsResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Cache read failed: $e');
      return null;
    }
  }

  Future<void> write(ProductsResponse response) async {
    try {
      await _storage.write(
        LocalStorageKeys.products,
        jsonEncode(response.toJson()),
      );
    } catch (e) {
      debugPrint('Cache write failed: $e');
    }
  }
}