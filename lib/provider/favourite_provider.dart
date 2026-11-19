import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/storage/favourite_storage.dart';

class FavouriteProvider extends ChangeNotifier {
  FavouriteProvider(this._storage) {
    for (final product in _storage.read()) {
      _items[product.id] = product;
    }
  }

  final FavouriteStorage _storage;
  final Map<int, Product> _items = {};

  List<Product> get items => _items.values.toList().reversed.toList();

  bool isFavourite(int id) => _items.containsKey(id);

  void toggle(Product product) {
    if (_items.remove(product.id) == null) {
      _items[product.id] = product;
    }
    notifyListeners();
    unawaited(_storage.write(_items.values.toList()));
  }
}
