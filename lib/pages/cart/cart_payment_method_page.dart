import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/payment_method.dart';
import 'package:supashop/pages/order/track_order_by_buyer_page.dart';
import 'package:supashop/pages/payment_method/payment_method_manager.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/repository/order_repository.dart';
import 'package:supashop/repository/payment_method_repository.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/global_values.dart';
import 'package:supashop/util/locale.dart';
import 'package:supashop/widgets/add_more_itens_in_cart.dart';
import 'package:supashop/widgets/footer_cart_continue.dart';
import 'package:supashop/widgets/payment_method_view.dart';

class CartPaymentMethodPage extends StatelessWidget {
  Cart cart;
  var paymentMethod = Rx<PaymentMethod?>(null);
  Future<PaymentMethod> paymentMethodFuture =
      Get.find<PaymentMethodRepository>().getLastUsedPaymentMethod();
  Account account = Get.find<AuthenticationService>().currentAccount!;
  CartRepository cartRepository = Get.find<CartRepository>();
  OrderRepository orderRepository = Get.find();

  CartPaymentMethodPage({required this.cart}) {
    paymentMethodFuture.then((value) => paymentMethod.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'.tr),
      ),
      body: ListView(
        children: [
          AddMoreItensInCart(
            storeName: cart.store.name,
            imageUrl: cart.store.image,
            onPressed: addMoreItens,
          ).paddingAll(kPadding),
          Text(
            "Summary of values".tr,
          ).paddingAll(kPadding),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Subtotal",
            ),
            Text(
              currencyFormat.format((cart.total - cart.deliveryFee) / 100),
            )
          ]).paddingSymmetric(horizontal: kPadding),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Delivery fee".tr,
            ),
            Text(
              currencyFormat.format(cart.deliveryFee / 100),
            )
          ]).paddingSymmetric(horizontal: kPadding),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Total".tr,
            ),
            Text(
              currencyFormat.format(cart.total / 100),
            ),
          ]).paddingOnly(left: kPadding, right: kPadding, bottom: kPadding),
          Divider(),
          Text(
            "Payment method".tr,
          ).paddingAll(kPadding),
          buildPaymentMethod()
              .paddingOnly(left: kPadding, right: kPadding, bottom: kPadding),
          Divider(),
          // TextFormField(
          //   initialValue: account.documentNumber,
          //   decoration: InputDecoration(
          //     labelText: 'Document number in invoice'.tr,
          //     hintText: '000.000.000-00'.tr,
          //     border: OutlineInputBorder(),
          //   ),
          //   keyboardType: TextInputType.name,
          //   inputFormatters: [
          //     if (Get.locale?.countryCode == 'BR')
          //       MaskTextInputFormatter(
          //         mask: "###.###.###-##",
          //         filter: {"#": RegExp(r'[0-9]')},
          //       )
          //   ],
          // ).paddingAll(kPadding),
        ],
      ),
      bottomNavigationBar: FutureBuilder(
        future: paymentMethodFuture,
        builder: (c, snap) => FooterCartContinue(
          continueLabel: 'Confirm'.tr,
          cart: cart,
          continueAction: snap.data == null ? null : sendOrder,
        ),
      ),
    );
  }

  void addMoreItens() {
    Get.back();
    Get.back();
    Get.back();
  }

  Widget buildPaymentMethod() {
    return FutureBuilder<PaymentMethod>(
      future: paymentMethodFuture,
      builder: (context, snapshot) {
        return Obx(() {
          paymentMethod.value;
          Widget header, body;
          if (snapshot.hasData) {
            header = Text(paymentMethod.value!.onApp
                ? 'Payment on app'.tr
                : 'Payment on delivery'.tr);
            body = Container(
              padding: EdgeInsets.all(kPaddingInternal),
              color: Colors.grey,
              child: PaymentMethodView(paymentMethod: paymentMethod.value!),
            );
          } else if (snapshot.hasError) {
            header =
                Text("${snapshot.error}", style: TextStyle(color: Colors.red));
            body = Container();
          } else {
            header = SkeletonLine(style: SkeletonLineStyle(width: 100));
            body = SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 3, padding: EdgeInsets.zero, spacing: 11));
          }
          return Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              header,
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: changePaymentMethod,
                  child: Text('Change'.tr)),
            ]),
            body,
          ]);
        });
      },
    );
  }

  Future<void> changePaymentMethod() async {
    PaymentMethod? newPaymentMethod =
        await Get.to(() => PaymentMethodManagerPage(
              paymentMethod: paymentMethod.value,
            ));
    if (newPaymentMethod == null) return;
    cart.paymentMethod = paymentMethod.value = newPaymentMethod;
  }

  Future<void> sendOrder() async {
    cart.paymentMethod = paymentMethod.value;
    cart.user = account;
    var order = await orderRepository.sendNewOrder(cart);
    await Get.offAll(() => TrackOrderPage(order));
    cart.items.clear();
    await cartRepository.saveCart(cart, removeIfEmpty: true);
  }
}