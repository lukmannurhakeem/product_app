import 'package:product_app/core/network/api_client.dart';
import 'package:product_app/core/network/api_endpoint.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/data/repositories/product_repository.dart';

class ProductsImpl implements ProductRepository {
  final ApiClient _apiClient;

  ProductsImpl(this._apiClient);

  @override
  Future<ProductsResponse> fetchProducts({required int limit, required int skip}) {
    return _apiClient.get<ProductsResponse>(
      ApiEndpoint.products,
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
      parser: (data) => ProductsResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}