import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/product_category.dart';

abstract class CategoryRepository {
  Future<List<ProductCategory>> getCategoriesByAddress(Address address);
}