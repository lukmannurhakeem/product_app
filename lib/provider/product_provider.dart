import 'package:flutter/material.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/data/repositories/product_repository.dart';
import 'package:product_app/service/snackbar_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository);

  List<Product> _products = [];

  List<Product> get products => _products;

  bool _isLoading = false;
  bool _hasError = false;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  static const int _limit = 20;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final model = await _productRepository.fetchProducts(
        limit: _limit,
        skip: 0,
      );
      _products = model.products;
    } catch (e, st) {
      _hasError = true;
      SnackbarService.showError(e, stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
