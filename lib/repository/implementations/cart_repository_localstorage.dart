import 'package:get/get.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/services/authentication_service.dart';

class LocalStorageCartRepository extends CartRepository {
  var mapIdCarts = <String, Cart>{};
  Map<String, Rx<Cart?>> cartStreams = {};

  Rx<Cart?> getRxCartStreamByEstablishment(Store establishment) {
    var cartId = 'cart_${establishment.id}';
    var stream = cartStreams[cartId];
    if (stream == null) {
      stream = Rx<Cart?>(null);
      cartStreams[cartId] = stream;
    }
    return stream;
  }

  @override
  Stream<Cart> getOrCreateCartByEstablishment(Store establishment) async* {
    var stream = getRxCartStreamByEstablishment(establishment);
    var cartId = 'cart_${establishment.id}';
    Cart? cart = mapIdCarts[cartId];
    if (cart == null) {
      cart = Cart(
          store: establishment,
          user: Get.find<AuthenticationService>().currentAccount);
      mapIdCarts[cartId] = cart;
    }
    Future(() {
      stream.value = cart;
      stream.refresh();
    });
    yield* stream.stream.where((event) => event != null).map((event) => event!);
  }

  Stream<Cart?> getIfExistCartByEstablishment(Store establishment) async* {
    var cartId = 'cart_${establishment.id}';
    Cart? cart = mapIdCarts[cartId];
    var stream = getRxCartStreamByEstablishment(establishment);
    stream.value = cart;
    Future(() => stream?.refresh());
    yield* stream.stream;
  }

  @override
  Future saveCart(Cart cart, {bool removeIfEmpty = true}) async {
    var cartId = 'cart_${cart.store.id}';
    var stream = cartStreams[cartId];
    if (removeIfEmpty && cart.items.isEmpty) {
      mapIdCarts.remove(cartId);
      stream?.value = null;
    } else {
      mapIdCarts[cartId] = cart;
      stream?.value = cart;
    }
    stream?.refresh();
  }

  @override
  Future<Iterable<Cart>> getAllCarts() async {
    return mapIdCarts.values;
  }
}