import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/i_order.dart';
import 'package:supashop/entities/order.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/repository/order_repository.dart';

class OrderRepositorySupabase extends OrderRepository {
  final supabase = Supabase.instance.client;

  final selectOrders = '*, '
      'stores(id, name, description, image, cover_image, classification), '
      'profiles(id, full_name)';

  @override
  Future<Iterable<Order>> getMyOrders() async {
    var list = await supabase.from('orders').select(selectOrders) as List;
    return list.map<Order>((e) => Order.fromJson(adapterJsonStore(e)));
  }

  @override
  Future<Order> sendNewOrder(Cart cart) async {
    var order = Order.fromCart(cart);
    var json = order.toJson();
    json['store_id'] = order.store.id;
    json['user_id'] = order.user.id;
    json.remove('store');
    json.remove('user');
    json.remove('evaluations');
    json.remove('modified_at');
    await supabase.from('orders').insert(json);
    return order;
  }

  @override
  Stream<Iterable<Order>> getOrdersByStore(Store store) async* {
    var stream = await supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('store_id', store.id)
    .order('created_at', ascending: false);

    yield* stream.asyncMap((list) async {
      var newList = await supabase
          .from('orders')
          .select(selectOrders)
          .in_('id', list.map((e) => e['id']).toList()) as List;
      return newList.map<Order>((e) => Order.fromJson(adapterJsonStore(e)));
    }).asBroadcastStream();
  }

  Map<String, dynamic> adapterJsonStore(Map<String, dynamic> json) {
    return json
      ..['store'] = json['stores']
      ..['user'] = json['profiles']
    ..['user']['name'] = json['profiles']['full_name']
      ..remove('stores')
      ..remove('profiles');
  }

  @override
  Future<void> setStatus(Order order, OrderStatus newStatus) async {
    await supabase
        .from('orders')
        .update({'status': newStatus.index}).eq('id', order.id);
    order.status = newStatus;
  }
}