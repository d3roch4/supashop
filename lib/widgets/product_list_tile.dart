import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/util/locale.dart';

class ProductListTile extends StatelessWidget {
  Product product;
  ValueChanged<Product> onTap;

  ProductListTile(this.product, this.onTap);

  @override
  Widget build(BuildContext context) {
    var styleName = Get.textTheme.titleSmall!;
    var stylePrice = styleName.copyWith(color: Colors.grey);
    return InkWell(
      child: Row(
        children: [
          Hero(
              tag: 'product-image-${product.id}',
              child: CachedNetworkImage(
                  imageUrl: product.images.first,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover)),
          SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(product.name, style: styleName),
                Text(product.description,
                        maxLines: 3, overflow: TextOverflow.ellipsis)
                    .paddingSymmetric(vertical: 8),
                Text(currencyFormat.format(product.price / 100),
                    style: stylePrice)
              ])),
        ],
      ),
      onTap: () => onTap(product),
    );
  }
}