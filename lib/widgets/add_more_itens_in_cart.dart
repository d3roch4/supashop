import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMoreItensInCart extends StatelessWidget {
  String? imageUrl;
  VoidCallback onPressed;
  String storeName;

  AddMoreItensInCart(
      {required this.onPressed, required this.storeName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (imageUrl != null)
          CachedNetworkImage(
            imageUrl: imageUrl!,
            width: 40,
            height: 40,
          ),
        SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            storeName,
            style: Get.textTheme.titleMedium,
          ),
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            onPressed: onPressed,
            child: Text('Add more itens'.tr),
          ),
        ]),
      ],
    );
  }
}