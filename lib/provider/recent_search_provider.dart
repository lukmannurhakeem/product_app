import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:product_app/storage/recent_search_storage.dart';

class RecentSearchProvider extends ChangeNotifier {
  RecentSearchProvider(this._storage) {
    _items.addAll(_storage.read().take(_max));
  }

  static const int _max = 5;

  final RecentSearchStorage _storage;
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;

    _items.removeWhere((e) => e.toLowerCase() == q.toLowerCase());
    _items.insert(0, q);
    if (_items.length > _max) _items.removeRange(_max, _items.length);

    notifyListeners();
    unawaited(_storage.write(_items));
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
    unawaited(_storage.write(_items));
  }
}
