import 'package:supashop/entities/entity.dart';

import 'address.dart';
import 'opening_hour.dart';
import 'product_category.dart';

class Store extends Entity {
  String name;
  String description;
  String image;
  String coverImage;
  Iterable<String> tags;
  double? classification;
  bool highlighted;
  List<ProductCategory> categories;
  String documentNumber;
  Map<int, List<OpeningHour>> openingHours;
  Address address;
  String currency;
  int deliveryFee;
  String phone;
  bool activated;

  Store({
    required this.name,
    required this.image,
    required this.coverImage,
    required this.description,
    required this.documentNumber,
    required this.address,
    required this.phone,
    this.classification,
    this.activated = false,
    this.tags = const [],
    this.highlighted = false,
    super.id,
    this.categories = const [],
    this.openingHours = const {},
    this.currency = 'BRL',
    this.deliveryFee = 0,
  });

  static Store fromJson(json) {
    Map<int, List<OpeningHour>> openingHours = json['opening_hours'] != null
        ? (json['opening_hours'] as Map<String, dynamic>).map((key, value) =>
            MapEntry(
                int.parse(key),
                value
                    .map<OpeningHour>((hour) => OpeningHour.fromJson(hour))
                    .toList()))
        : {};
    return Store(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? json['profileImage'],
      coverImage: json['cover_image'] ?? json['coverImage'],
      description: json['description'],
      classification: json['classification'],
      documentNumber: json['document_number'] ?? '00000000000000',
      currency: json['currency'] ?? 'BRL',
      address: Address.fromJson(json['address']),
      phone: json['phone'] ?? '',
      tags: (json['tags'] as List? ?? []).map((t) => t.toString()),
      highlighted: json['highlighted'] ?? false,
      categories: (json['categories'] ?? json['categorys'] as List? ?? [])
          .map<ProductCategory>(
              (category) => ProductCategory.fromJson(category))
          .toList(),
      openingHours: openingHours,
      deliveryFee: json['delivery_fee'] ?? 0,
      activated: json['activated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cover_image': coverImage,
      'description': description,
      'classification': classification,
      'document_number': documentNumber,
      'phone': phone,
      'address': address.toJson(),
      'tags': tags.toList(),
      'highlighted': highlighted,
      'categories': categories.map((category) => category.toJson()).toList(),
      'openingHours': openingHours.map((key, value) => MapEntry(
          key.toString(), value.map((hour) => hour.toJson()).toList())),
      'currency': currency,
      'delivery_fee': deliveryFee,
      'activated': activated,
    };
  }
}

class StoreSetup {
  int? id;
  String storeId;
  double percentFee;
  int fixedFee;

  StoreSetup({
    this.id,
    required this.storeId,
    required this.percentFee,
    required this.fixedFee,
  });

  static StoreSetup fromJson(json) {
    return StoreSetup(
      id: json['id'],
      storeId: json['store_id'],
      percentFee: json['percent_fee'],
      fixedFee: json['fixed_fee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'percent_fee': percentFee,
      'fixed_fee': fixedFee,
    };
  }
}