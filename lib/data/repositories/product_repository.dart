import 'package:product_app/data/model/products_response/products_response.dart';

abstract class ProductRepository {
  Future<ProductsResponse> fetchProducts({required int limit, required int skip});
}