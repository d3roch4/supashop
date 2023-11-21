import 'package:get/get.dart';
import 'package:medartor/medartor.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/repository/store_repository.dart';

class AddProductToCart implements IRequest<Cart> {
  Product product;
  int countProduct;

  AddProductToCart(this.product, [this.countProduct = 1]);
}

class AddProductToCartHandler extends IRequestHandler<AddProductToCart, Cart> {
  CartRepository cartRepository = Get.find();
  StoreRepository establishmentRepository = Get.find();

  @override
  Future<Cart> handle(AddProductToCart request) async {
    var establishment = await establishmentRepository
        .getStoreByIdWithProducts(request.product.storeId);
    var cart = await cartRepository
        .getOrCreateCartByEstablishment(establishment!)
        .first;
    cart.addProduct(
        Product.fromJson(request.product.toJson()), request.countProduct);
    await cartRepository.saveCart(cart);
    return cart;
  }
}