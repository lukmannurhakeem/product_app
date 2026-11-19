import 'dart:async';

import 'package:product_app/core/network/api_client.dart';
import 'package:product_app/core/network/api_endpoint.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/data/repositories/product_repository.dart';
import 'package:product_app/storage/product_storage.dart';

class ProductsImpl implements ProductRepository {
  final ApiClient _apiClient;
  final ProductStorage _productStorage;

  ProductsImpl(this._apiClient, this._productStorage);

  @override
  Future<ProductsResponse> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final response = await _apiClient.get<ProductsResponse>(
      ApiEndpoint.products,
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
      parser: (data) => ProductsResponse.fromJson(data as Map<String, dynamic>),
    );
    if (skip == 0) unawaited(_productStorage.write(response));
    return response;
  }

  @override
  Future<ProductsResponse> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) {
    return _apiClient.get<ProductsResponse>(
      ApiEndpoint.productsSearch,
      queryParameters: {
        'q': query,
        'limit': limit,
        'skip': skip,
      },
      parser: (data) => ProductsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  ProductsResponse? getCachedProducts() => _productStorage.read();
}