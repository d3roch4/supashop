import 'dart:async';

import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/model/search_result_item.dart';

abstract class ProductRepository {
  FutureOr<void> saveProduct(Product product);

  Future<Iterable<Product>> getProductsByStore(Store store);

  Future<Product?> getProductById(String productId);

  Future<Iterable<SearchResultItem>> searchProducts(String query);
}