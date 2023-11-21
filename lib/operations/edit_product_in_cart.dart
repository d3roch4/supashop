import 'package:get/get.dart';
import 'package:medartor/medartor.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/repository/store_repository.dart';

class EditProductInCart implements IRequest<Cart> {
  Product product;
  int countProduct;

  EditProductInCart(this.product, [this.countProduct = 1]);
}

class EditProductInCartHandler
    extends IRequestHandler<EditProductInCart, Cart> {
  CartRepository cartRepository = Get.find();
  StoreRepository establishmentRepository = Get.find();

  @override
  Future<Cart> handle(EditProductInCart request) async {
    var store = await establishmentRepository
        .getStoreByIdWithProducts(request.product.storeId);
    var cart =
        await cartRepository.getOrCreateCartByEstablishment(store!).first;

    var existentItem = cart.getCartItemByProduct(request.product);
    if (existentItem != null) {
      existentItem.quantity = request.countProduct;
      //existentItem.product =
    }
    return cart;
  }
}