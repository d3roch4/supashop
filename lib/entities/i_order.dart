import 'purchase_item.dart';
import 'store.dart';

abstract interface class IOrder {
  Store get store;

  Iterable<PurchaseItem> get items;

  int get deliveryFee;

  int get total;

  Iterable<Duration> get estimatedDeliveryTime;

  OrderStatus get status;
}

enum OrderStatus {
  unknow,
  waiting,
  inPreparation,
  sending,
  delivered,
  canceled,
}