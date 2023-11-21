import 'package:supashop/entities/product.dart';

class PurchaseItem {
  int quantity;
  int price;
  Product product;
  String? observation;

  int get total => quantity * price;

  PurchaseItem({
    required this.quantity,
    required this.price,
    required this.product,
    this.observation,
  });

  static PurchaseItem fromJson(item) {
    return PurchaseItem(
      quantity: item['quantity'],
      price: item['price'],
      product: Product.fromJson(item['product']),
      observation: item['observation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'price': price,
      'product': product.toJson(),
      'observation': observation,
    };
  }
}