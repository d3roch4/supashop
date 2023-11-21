import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/order.dart';
import 'package:supashop/entities/store.dart';

import '../entities/i_order.dart';

abstract class OrderRepository {
  Future<Order> sendNewOrder(Cart cart);

  Future<Iterable<Order>> getMyOrders();

  Stream<Iterable<Order>> getOrdersByStore(Store store);

  Future<void> setStatus(Order order, OrderStatus status);
}