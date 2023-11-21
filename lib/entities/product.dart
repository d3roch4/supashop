import 'package:supashop/entities/entity.dart';

import 'complement.dart';

class Product extends Entity {
  List<String> images;
  String name;
  String description;
  int price;
  double preparationTime;
  List<Complement> complements;
  String storeId;
  List<String> categoryIds;

  Product({
    super.id,
    super.createdAt,
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.preparationTime,
    this.complements = const [],
    this.storeId = '',
    this.categoryIds = const [],
  });

  static Product fromJson(product) {
    return Product(
      id: product['id'],
      createdAt: DateTime.parse(product['created_at']),
      images: (product['images'] ?? '').split(',').toList(),
      name: product['name'],
      description: product['description'] ?? '',
      price: (product['price'] as num).toInt(),
      preparationTime: (product['preparation_time'] as num?)?.toDouble() ?? 0,
      complements: (product['complements'] ?? [] as List)
          .map<Complement>((complement) => Complement.fromJson(complement))
          .toList(),
      storeId: 'store_id',
      categoryIds: (product['category_ids'] ?? '').split(',').toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'images': images.join(','),
      'name': name,
      'description': description,
      'price': price,
      'preparation_time': preparationTime,
      'complements':
          complements.map((complement) => complement.toJson()).toList(),
      'store_id': storeId,
      'category_ids': categoryIds.join(','),
    };
  }
}