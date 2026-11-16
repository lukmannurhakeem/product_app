import 'package:flutter/material.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/data/repositories/product_repository.dart';
import 'package:product_app/service/snackbar_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository);

  static const int _limit = 20;

  List<Product> _products = [];

  List<Product> get products => _products;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  bool _hasMore = true;
  int _fetchIncrement = 0;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasError => _hasError;

  bool get hasMore => _hasMore;

  Future<void> fetchProducts() async {
    final increment = ++_fetchIncrement;
    _isLoading = true;
    _isLoadingMore = false;
    _hasError = false;
    _hasMore = true;
    notifyListeners();

    try {
      final model = await _productRepository.fetchProducts(
        limit: _limit,
        skip: 0,
      );
      if (increment != _fetchIncrement) return;

      _products = model.products;
      _hasMore = model.products.isNotEmpty && _products.length < model.total;
    } catch (e, st) {
      if (increment != _fetchIncrement) return;
      _hasError = true;
      SnackbarService.showError(e, stackTrace: st);
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
      final model = await _productRepository.fetchProducts(
        limit: _limit,
        skip: _products.length,
      );
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
}