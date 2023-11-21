import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supashop/entities/payment_method.dart';
import 'package:supashop/widgets/card_brand_icon.dart';

class PaymentMethodView extends StatelessWidget {
  PaymentMethod paymentMethod;
  bool inline;

  PaymentMethodView({required this.paymentMethod, this.inline = false});

  @override
  Widget build(BuildContext context) {
    var styleName = Get.textTheme.titleSmall!;
    var styleCardNumber = Get.textTheme.labelSmall!;

    if (inline) return buildInline(styleCardNumber);
    return buildComplete(styleName, styleCardNumber);
  }

  Widget buildInline(TextStyle styleText) {
    return Row(
      children: [
        Expanded(
            child: Text(
                paymentMethod.onApp
                    ? 'Payment on app'.tr
                    : 'Payment on delivery'.tr,
                style: styleText,
                overflow: TextOverflow.fade)),
        CardBrandIcon(paymentMethod: paymentMethod, width: 30),
        if (paymentMethod.brand != null)
          Text(paymentMethod.brand!, style: styleText),
        if (paymentMethod.cardNumber != null)
          Text(
              '**** ${paymentMethod.cardNumber!.substring(paymentMethod.cardNumber!.length - 4)}',
              style: styleText),
      ],
    );
  }

  Widget buildComplete(TextStyle styleName, TextStyle styleCardNumber) {
    var title = Text.rich(
      softWrap: true,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        children: [
          TextSpan(
              text: [
                if (paymentMethod.name.isNotEmpty) paymentMethod.name.tr,
                if (paymentMethod.operationName.isNotEmpty)
                  paymentMethod.operationName.tr
              ].join(' • '),
              style: styleName),
          if (paymentMethod.withProblems)
            TextSpan(
              text: ' • Card with problems'.tr,
              style: styleName.copyWith(color: Colors.accents.first),
            ),
        ],
      ),
    );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      CardBrandIcon(paymentMethod: paymentMethod),
      SizedBox(width: 8),
      Expanded(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            title,
            if (paymentMethod.cardNumber != null)
              Text(
                  '${toBeginningOfSentenceCase(paymentMethod.brand)} ${paymentMethod.cardNumber}',
                  overflow: TextOverflow.ellipsis,
                  style: styleCardNumber),
          ])),
    ]);
  }
}