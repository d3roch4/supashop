import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supashop/entities/payment_method.dart';

class CardBrandIcon extends StatelessWidget {
  PaymentMethod paymentMethod;
  double width;

  CardBrandIcon({required this.paymentMethod, this.width = 50});

  @override
  Widget build(BuildContext context) {
    if (paymentMethod.type == PaymentMethodType.cash)
      return Container(
        width: width,
        child: Icon(Icons.currency_exchange),
      );
    if (paymentMethod.brand?.isNotEmpty ?? false) {
      try {
        return SvgPicture(
          SvgNetworkLoader(
              'https://github.com/aaronfagan/svg-credit-card-payment-icons/raw/main/logo/${paymentMethod.brand?.toLowerCase()}.svg'),
          width: width,
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st, label: e.toString());
      }
    }
    return Container(
      width: width,
      child: Icon(Icons.credit_card),
    );
  }
}