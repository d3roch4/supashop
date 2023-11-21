import 'package:supashop/entities/entity.dart';

class Complement extends Entity {
  String name;
  String description;
  int? min;
  int? max;
  List<ComplementItem> itens;

  bool get onlyOne => max == 1 && min == 1;

  Complement({
    super.id,
    required this.name,
    required this.description,
    required this.min,
    required this.max,
    required this.itens,
  });

  static Complement fromJson(complement) {
    return Complement(
      id: complement['id'],
      name: complement['name'],
      description: complement['description'],
      min: complement['min'],
      max: complement['max'],
      itens: complement['itens']
          .map<ComplementItem>((item) => ComplementItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'min': min,
      'max': max,
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }
}

class ComplementItem extends Entity {
  String name;
  String description;
  String image;
  int count;
  int price;

  ComplementItem({
    super.id,
    required this.name,
    required this.description,
    required this.image,
    required this.count,
    required this.price,
  });

  static ComplementItem fromJson(item) {
    return ComplementItem(
      id: item['id'],
      name: item['name'],
      description: item['description'],
      image: item['image'],
      count: item['count'],
      price: item['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'count': count,
      'price': price,
    };
  }
}