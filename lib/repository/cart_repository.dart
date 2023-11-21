import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/store.dart';

abstract class CartRepository {
  Stream<Cart> getOrCreateCartByEstablishment(Store establishment);

  Stream<Cart?> getIfExistCartByEstablishment(Store establishment);

  Future saveCart(Cart cart, {bool removeIfEmpty = true});

  Future<Iterable<Cart>> getAllCarts();
}