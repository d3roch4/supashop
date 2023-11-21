import 'package:supashop/entities/entity.dart';

import 'product.dart';

class ProductCategory extends Entity {
  String name;
  String? image;
  Iterable<Product> products;

  ProductCategory({
    super.id,
    required this.name,
    this.image,
    this.products = const [],
  });

  static ProductCategory fromJson(category) {
    return ProductCategory(
      id: category['id'],
      name: category['name'],
      image: category['image'],
      products: (category['products'] ?? category['categoryItems'])
          .map<Product>((product) => Product.fromJson(product))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}