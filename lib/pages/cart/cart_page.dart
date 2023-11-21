import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/purchase_item.dart';
import 'package:supashop/pages/cart/cart_edit_address_page.dart';
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/pages/product/product_view_page.dart';
import 'package:supashop/pages/store/store_view_page.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/add_more_itens_in_cart.dart';
import 'package:supashop/widgets/count_number_input.dart';
import 'package:supashop/widgets/footer_cart_continue.dart';

class CartPage extends StatefulWidget {
  Cart cart;

  CartPage({required this.cart, super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartRepository cartRepository = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'.tr),
        actions: [TextButton(child: Text('Clear'.tr), onPressed: clear)],
      ),
      body: ListView(children: [
        AddMoreItensInCart(
          storeName: widget.cart.store.name,
          imageUrl: widget.cart.store.image,
          onPressed: gotoEstablishment,
        ).paddingAll(kPadding),
        for (var item in widget.cart.items) buildItem(item),
      ]),
      bottomNavigationBar:
          FooterCartContinue(cart: widget.cart, continueAction: continueBuy),
    );
  }

  void clear() {
    widget.cart.items.clear();
    cartRepository.saveCart(widget.cart);
    setState(() {});
  }

  Widget buildItem(PurchaseItem item) {
    var complements = item.product.complements.map((c) {
      var itensCountName = c.itens
          .where((e) => e.count > 0)
          .map((i) => '${c.onlyOne ? '*' : i.count} ${i.name}');
      return '${c.name}:\n\t\t${itensCountName.join('\n\t\t')}';
    });
    var observation = [
      item.observation ?? 'Click here to edit observation'.tr,
      ...complements
    ].join('\n');
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border()),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: item.product.images.first,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
          SizedBox(width: kPadding),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
              ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () => editObservation(item),
                child: Text(
                  observation,
                ),
              ),
              CountNumberInput(
                iconSize: 16,
                padding: EdgeInsets.all(4),
                value: item.quantity,
                iconIfOne: Icon(Icons.delete),
                onChanged: (value) => removeItem(value, item),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormat.format(item.total / 100),
                  ),
                  TextButton.icon(
                    onPressed: () => editItem(item),
                    icon: Icon(Icons.edit, size: 16),
                    label: Text('Edit item'.tr),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  Future<void> editObservation(PurchaseItem item) async {
    await showDialog(
        context: Get.context!,
        builder: (context) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.product.name),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Observation'.tr,
                    ),
                    controller: TextEditingController(text: item.observation),
                    onEditingComplete: Get.back,
                    onChanged: (value) {
                      if (value.isNotEmpty)
                        item.observation = value;
                      else
                        item.observation = null;
                    },
                  ),
                  TextButton(onPressed: () => Get.back(), child: Text('Ok'.tr)),
                ],
              ).paddingAll(kPadding),
            ));
    setState(() {});
  }

  Future<void> removeItem(int value, PurchaseItem item) async {
    item.quantity = value;
    if (value == 0) widget.cart.items.remove(item);
    await cartRepository.saveCart(widget.cart);
    setState(() {});
  }

  Future<void> editItem(PurchaseItem item) async {
    var quantity = await Get.toNamed(
      ProductViewPage.routePath.replaceFirst(':id', item.product.id.toString()),
      arguments: item,
      parameters: {'editCartItem': 'true', 'count': item.quantity.toString()},
    );
    item.quantity = quantity;
    await cartRepository.saveCart(widget.cart);
    setState(() {});
  }

  Future<void> continueBuy() async {
    if (Get.find<AuthenticationService>().currentAccount == null) {
      var account = await Get.toNamed(LoginPage.routePath);
      if (account == null) return;
    }
    Get.to(() => CartEditAddressPage(cart: widget.cart));
  }

  void gotoEstablishment() {
    if (Get.routing.previous == EstablishmentViewPage.routePath ||
        Get.routing.previous == ProductViewPage.routePath)
      Get.back();
    else
      Get.toNamed(EstablishmentViewPage.routePath,
          arguments: widget.cart.store, preventDuplicates: true);
  }
}