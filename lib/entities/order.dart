import 'package:collection/collection.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/entities/entity.dart';
import 'package:supashop/entities/i_order.dart';

import 'address.dart';
import 'cart.dart';
import 'message.dart';
import 'payment_method.dart';
import 'purchase_item.dart';
import 'store.dart';

class Order extends Entity implements IOrder {
  Account user;
  @override
  Store store;
  @override
  List<PurchaseItem> items;
  Address? address;
  PaymentMethod paymentMethod;
  List<OrderEvaluation> evaluations;
  OrderStatus status;
  @override
  int deliveryFee;
  List<Message> messages;

  Order({
    super.id,
    super.createdAt,
    super.modifiedAt,
    required this.user,
    required this.store,
    required this.paymentMethod,
    required this.deliveryFee,
    this.evaluations = const [],
    this.status = OrderStatus.unknow,
    this.items = const [],
    this.address,
    this.messages = const [],
  }) {
    assert(items.isNotEmpty, 'items must not be empty');
  }

  factory Order.fromCart(Cart cart) {
    assert(cart.user != null, 'cart.user must not be null');
    return Order(
      user: cart.user!,
      store: cart.store,
      paymentMethod: cart.paymentMethod!,
      deliveryFee: cart.deliveryFee,
      items: [...cart.items],
      address: cart.address,
      status: OrderStatus.waiting,
    );
  }

  @override
  int get total => deliveryFee + items.map((e) => e.total).sum;

  @override
  Iterable<Duration> estimatedDeliveryTime = [Duration(minutes: 30)];

  toJson() {
    return {
      'id': id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'modified_at': modifiedAt?.toUtc().toIso8601String(),
      'user': user.toJson(),
      'store': store.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'address': address?.toJson(),
      'payment_method': paymentMethod.toJson(),
      'evaluations': evaluations.map((e) => e.toJson()).toList(),
      'status': status.index,
      'delivery_fee': deliveryFee,
    };
  }

  static fromJson(json) {
    return Order(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      modifiedAt: DateTime.tryParse(json['modified_at'] ?? ''),
      user: Account.fromJson(json['user']),
      store: Store.fromJson(json['store']),
      items:
          (json['items'] as List).map((e) => PurchaseItem.fromJson(e)).toList(),
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      paymentMethod: PaymentMethod.fromJson(json['payment_method']),
      evaluations: (json['evaluations'] as List? ?? [])
          .map<OrderEvaluation>((e) => OrderEvaluation.fromJson(e))
          .toList(),
      status: OrderStatus.values[json['status']],
      deliveryFee: json['delivery_fee'],
    );
  }
}

class OrderEvaluation extends Entity {
  Account account;
  String? comment;
  double classification;

  OrderEvaluation({
    super.id,
    super.createdAt,
    required this.account,
    required this.classification,
    this.comment,
  });

  toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'account': account.toJson(),
      'comment': comment,
      'classification': classification,
    };
  }

  static fromJson(json) {
    return OrderEvaluation(
      id: json['id'],
      createdAt: json['created_at'],
      account: Account.fromJson(json['account']),
      comment: json['comment'],
      classification: json['classification'],
    );
  }
}