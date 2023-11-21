import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/order.dart';
import 'package:supashop/pages/cart/cart_page.dart';
import 'package:supashop/pages/order/track_order_by_buyer_page.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/repository/order_repository.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/loadding_widget.dart';
import 'package:supashop/widgets/order_in_progress_tile.dart';

class OrderListPage extends StatelessWidget {
  var ordersInProgressFuture = Get.find<OrderRepository>().getMyOrders();
  var cartsInProgressFuture = Get.find<CartRepository>().getAllCarts();
  late Iterable<Order> ordersInProgress;
  late Iterable<Cart> cartsInProgress;

  @override
  Widget build(BuildContext context) {
    return LoaddingWidget.future(
        future: waitFutures(),
        builder: (_) {
          return ListView(
            padding: EdgeInsets.all(kPadding),
            children: [
              if (cartsInProgress.isNotEmpty)
                Text(
                  'Open carts'.tr,
                  textAlign: TextAlign.center,
                ).paddingSymmetric(vertical: 16),
              for (var cart in cartsInProgress)
                OrderInProgressTile(
                  cart,
                  onTap: () => openCart(cart),
                ).marginOnly(bottom: kPadding),
              Text(
                'My orders'.tr,
                textAlign: TextAlign.center,
              ).paddingSymmetric(vertical: 16),
              for (var order in ordersInProgress)
                OrderInProgressTile(
                  order,
                  onTap: () => openOrder(order),
                ).marginOnly(bottom: kPadding),
            ],
          );
        });
  }

  Future<void> waitFutures() async {
    ordersInProgress = await ordersInProgressFuture;
    cartsInProgress = await cartsInProgressFuture;
  }

  void openCart(Cart cart) {
    Get.to(() => CartPage(cart: cart));
  }

  void openOrder(Order order) {
    Get.to(() => TrackOrderPage(order, backToHome: false));
  }
}