import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/util/util.dart';

import 'bottom_conteiner.dart';

class FooterCartContinue extends StatelessWidget {
  Cart cart;
  Function()? continueAction;
  String continueLabel;

  FooterCartContinue(
      {required this.cart,
      required this.continueAction,
      this.continueLabel = 'Continue'});

  @override
  Widget build(BuildContext context) {
    return BottomConteiner(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total com a entrega',
              style: Get.textTheme.labelSmall!,
            ),
            const SizedBox(width: 56),
            Expanded(
                child: Text(
              currencyFormat.format(cart.total / 100),
              style: Get.textTheme.titleMedium,
            )),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ButtonStyle(
              fixedSize:
                  MaterialStatePropertyAll(Size.fromWidth(double.maxFinite))),
          child: Text(continueLabel.tr),
          onPressed: cart.items.isEmpty ? null : continueAction,
        ),
      ],
    ));
  }
}