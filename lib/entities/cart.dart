import 'package:get/get.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/entity.dart';
import 'package:supashop/entities/i_order.dart';
import 'package:supashop/entities/payment_method.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/store.dart';

import 'purchase_item.dart';

class Cart extends Entity implements IOrder {
  Account? user;
  @override
  Store store;
  @override
  List<PurchaseItem> items;
  Address? address;
  PaymentMethod? paymentMethod;

  @override
  Iterable<Duration> estimatedDeliveryTime = [const Duration(minutes: 30)];

  @override
  int get deliveryFee => store.deliveryFee;

  @override
  int get total {
    if (items.isEmpty) return 0;
    var totalItens = items.map((item) => item.total).reduce((a, b) => a + b);
    return totalItens + deliveryFee;
  }

  @override
  OrderStatus get status => OrderStatus.unknow;

  Cart({
    super.id,
    super.createdAt,
    super.modifiedAt,
    required this.user,
    required this.store,
    List<PurchaseItem>? items,
    this.address,
    this.paymentMethod,
  }) : items = items ?? [];

  PurchaseItem? getCartItemByProduct(Product product) {
    tokenizedComplementsCount(c) =>
        c.itens.map((i) => '${i.id}-${i.count}').join();
    var existingItem = items.firstWhereOrNull((item) =>
        item.product.id == product.id &&
        item.product.complements.map(tokenizedComplementsCount).join() ==
            product.complements.map(tokenizedComplementsCount).join());
    return existingItem;
  }

  void addProduct(Product product, int countProduct) {
    int totalComplements = 0;
    for (var c in product.complements)
      for (var i in c.itens) if (i.count > 0) totalComplements += i.price;
    var existingItem = getCartItemByProduct(product);
    if (existingItem != null)
      existingItem.quantity += countProduct;
    else
      items.add(PurchaseItem(
        quantity: countProduct,
        price: product.price + totalComplements,
        product: product,
      ));
  }

  static Cart fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      modifiedAt: DateTime.tryParse(json['modified_at'] ?? ''),
      user: Account.fromJson(json['user']),
      store: Store.fromJson(json['establishment']),
      items: json['items']
          .map<PurchaseItem>((item) => PurchaseItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'modified_at': modifiedAt?.toUtc().toIso8601String(),
      'user': user?.toJson(),
      'establishment': store.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}