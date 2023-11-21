import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/pages/cart/cart_change_delivery_address_page.dart';
import 'package:supashop/repository/address_repository.dart';
import 'package:supashop/util/locale.dart';
import 'package:supashop/widgets/footer_cart_continue.dart';
import 'package:supashop/widgets/icon_address_type.dart';

import '../../entities/cart.dart';
import 'cart_payment_method_page.dart';

class CartEditAddressPage extends StatefulWidget {
  static var routePath = '/cart/edit/address';

  Cart cart;

  CartEditAddressPage({super.key, required this.cart});

  @override
  State<CartEditAddressPage> createState() => _CartEditAddressPageState();
}

class _CartEditAddressPageState extends State<CartEditAddressPage> {
  Future<Address?> addressFuture =
      Get.find<AddressRepository>().getLastUsedAddress();

  @override
  void initState() {
    super.initState();
    addressFuture.then((value) {
      widget.cart.address = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliver in:'.tr),
      ),
      body: ListView(
        children: [
          buildAddress(),
          Divider(),
          ListTile(
            title: Text('Delivery information'.tr),
            subtitle:
                Text('Delivery made by: %s'.trArgs([widget.cart.store.name])),
            trailing: Text(
              currencyFormat.format(widget.cart.deliveryFee / 100).tr,
            ),
          ),
        ],
      ),
      bottomNavigationBar: FutureBuilder(
        future: addressFuture,
        builder: (c, snap) => FooterCartContinue(
          cart: widget.cart,
          continueAction: snap.data == null ? null : continerAction,
        ),
      ),
    );
  }

  void continerAction() {
    Get.to(() => CartPaymentMethodPage(cart: widget.cart));
  }

  Widget buildAddress() {
    return FutureBuilder(
      future: addressFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting)
          return SkeletonParagraph(style: SkeletonParagraphStyle(lines: 2));

        if (snapshot.data == null)
          return ListTile(
            title: Text('No address selected'.tr),
            subtitle: Text('Select an address to continue'.tr),
            trailing: Text(
              'Change'.tr,
            ),
            onTap: changeAddress,
          );

        var address = widget.cart.address!;
        return ListTile(
          title: Text('${address.street}, ${address.number}'),
          subtitle:
              Text('${address.neighborhood} - ${address.complement ?? ''}'),
          leading: IconAddressType(type: address.type),
          trailing: Text(
            'Change'.tr,
          ),
          onTap: changeAddress,
        );
      },
    );
  }

  Future<void> changeAddress() async {
    var newAddress = await Get.to(
      () => CartChangeDeliveryAddressPage(
        addressSelected: widget.cart.address,
      ),
      routeName: CartEditAddressPage.routePath,
      preventDuplicates: false,
    );
    if (newAddress == null) return;
    setState(() {
      addressFuture = Future.value(widget.cart.address = newAddress);
    });
  }
}