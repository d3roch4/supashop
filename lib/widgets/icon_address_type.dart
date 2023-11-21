import 'package:flutter/material.dart';
import 'package:supashop/entities/address.dart';

class IconAddressType extends StatelessWidget {
  final AddressType type;

  IconAddressType({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AddressType.home:
        return Icon(Icons.home);
      case AddressType.work:
        return Icon(Icons.work);
      default:
        return Icon(Icons.pin_drop_outlined);
    }
  }
}