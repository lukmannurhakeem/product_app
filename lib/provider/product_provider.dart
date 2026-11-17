import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_app/core/errors/app_exception.dart';
import 'package:product_app/core/errors/error_handler.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/data/repositories/product_repository.dart';
import 'package:product_app/service/snackbar_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository);

  static const int _limit = 20;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  List<Product> _products = [];

  List<Product> get products => _products;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _fetchIncrement = 0;
  AppException? _error;

  String _query = '';
  Timer? _debounce;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  AppException? get error => _error;

  bool get hasError => _error != null;

  bool get hasMore => _hasMore;

  String get query => _query;

  Future<void> fetchProducts() async {
    final increment = ++_fetchIncrement;
    _isLoading = true;
    _isLoadingMore = false;
    _error = null;
    _hasMore = true;
    notifyListeners();

    try {
      final model = await _request(0);
      if (increment != _fetchIncrement) return;

      _products = model.products;
      _hasMore = model.products.isNotEmpty && _products.length < model.total;
    } catch (e, st) {
      if (increment != _fetchIncrement) return;
      _error = ErrorHandler.handle(e, st);
      if (_products.isNotEmpty) {
        SnackbarService.showError(e, stackTrace: st);
      }
    } finally {
      if (increment == _fetchIncrement) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    final increment = _fetchIncrement;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final model = await _request(_products.length);
      if (increment != _fetchIncrement) return;

      final existingIds = _products.map((p) => p.id).toSet();
      final newItems = model.products.where((p) => !existingIds.contains(p.id));
      _products = [..._products, ...newItems];

      _hasMore = model.products.isNotEmpty && _products.length < model.total;
    } catch (e, st) {
      if (increment != _fetchIncrement) return;
      SnackbarService.showError(e, stackTrace: st);
    } finally {
      if (increment == _fetchIncrement) {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  Future<ProductsResponse> _request(int skip) {
    if (_query.isEmpty) {
      return _productRepository.fetchProducts(limit: _limit, skip: skip);
    }
    return _productRepository.searchProducts(
      query: _query,
      limit: _limit,
      skip: skip,
    );
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      final newQuery = value.trim();
      if (newQuery == _query) return;
      _query = newQuery;
      _products = [];
      fetchProducts();
    });
  }

  void resetSearch() {
    _debounce?.cancel();
    _query = '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}