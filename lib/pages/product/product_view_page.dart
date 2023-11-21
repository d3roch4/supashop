import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medartor/medartor.dart';
import 'package:supashop/entities/complement.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/operations/add_product_to_cart.dart';
import 'package:supashop/pages/cart/cart_page.dart';
import 'package:supashop/util/locale.dart';
import 'package:supashop/widgets/back_button_blur.dart';
import 'package:supashop/widgets/count_number_input.dart';

class ProductViewPage extends StatefulWidget {
  static var routePath = '/product/:id';
  Product product;
  bool editCartItem;
  int countProduct;

  ProductViewPage({
    super.key,
    Product? product,
    this.editCartItem = false,
    this.countProduct = 1,
  }) : product = product ?? Get.arguments;

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  Medartor mediator = Get.find();
  var enableAdd = true;
  int total = 0;
  var styleComplementName = Get.textTheme.titleSmall;
  var styleComplementDescription = Get.textTheme.bodySmall;
  var styleComplementItemName = Get.textTheme.labelLarge;
  var styleComplementItemDescription = Get.textTheme.labelSmall;
  var stylePriceItem = Get.textTheme.labelMedium;

  @override
  void initState() {
    super.initState();
    checkMinAndMaxItens();
    total = widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        buildImageTop(),
        buildInformations(),
        for (var complement in widget.product.complements)
          buildComplement(complement),
      ]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        height: 88,
        decoration: BoxDecoration(border: Border()),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CountNumberInput(
            min: 1,
            value: widget.countProduct,
            onChanged: (v) => setState(() {
              widget.countProduct = v;
              checkMinAndMaxItens();
            }),
          ),
          SizedBox(width: 8),
          ElevatedButton(
              onPressed: enableAdd ? add : null,
              child: Text(
                '${widget.editCartItem ? 'Change' : 'Add'} %s'
                    .trArgs([currencyFormat.format(total / 100)]),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ))
        ]),
      ),
    );
  }

  Widget buildImageTop() {
    return Stack(children: [
      AspectRatio(
        aspectRatio: 1,
        child: Hero(
            tag: 'product-image-${widget.product.id}',
            child: CachedNetworkImage(
                imageUrl: widget.product.images.first, fit: BoxFit.cover)),
      ),
      Positioned(
        child: BackButtonBlur(),
        top: 16,
        left: 16,
      ),
    ]);
  }

  Widget buildInformations() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.product.name,
        style: Get.textTheme.titleLarge,
      ),
      SizedBox(height: 8),
      Text(widget.product.description),
      SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currencyFormat.format(widget.product.price / 100),
            style: Get.textTheme.titleMedium,
          ),
          if (widget.product.preparationTime > 0)
            Text(
              '${numberFormat.format(widget.product.preparationTime)} min',
              textAlign: TextAlign.right,
            )
        ],
      ),
    ]).paddingSymmetric(horizontal: 16, vertical: 24);
  }

  Future<void> add() async {
    if (widget.editCartItem) {
      return Get.back(result: widget.countProduct);
    }
    var cart = await mediator
        .send(AddProductToCart(widget.product, widget.countProduct));
    Get.off(() => CartPage(cart: cart));
  }

  Widget buildComplement(Complement complement) {
    var countItens = complement.itens.map((e) => e.count).sum;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(complement.name, style: styleComplementName)),
        Chip(
          label:
              Text((complement.min ?? 0) == 0 ? 'Optional'.tr : 'Required'.tr),
        ),
      ]).paddingSymmetric(horizontal: 16),
      Text(complement.description, style: styleComplementDescription)
          .paddingSymmetric(horizontal: 16),
      for (var item in complement.itens)
        buildComplementItem(item, complement, countItens),
    ]).paddingOnly(top: 32);
  }

  Widget buildComplementItem(
      ComplementItem item, Complement complement, int countItens) {
    return Container(
      decoration: BoxDecoration(
        border: Border(),
      ),
      padding: EdgeInsets.all(16),
      child: Row(children: [
        if (item.image.isNotEmpty)
          CachedNetworkImage(
            imageUrl: item.image,
            height: 56,
            width: 56,
            fit: BoxFit.cover,
          ).paddingOnly(right: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: styleComplementItemName),
          if (item.description.isNotEmpty)
            Text(item.description, style: styleComplementItemDescription),
          if (item.price > 0)
            Text('+ ${currencyFormat.format(item.price / 100)}',
                style: stylePriceItem),
        ])),
        if (complement.onlyOne)
          Radio<String?>(
              value: item.id,
              groupValue: complement.id,
              onChanged: (value) {
                for (var i in complement.itens) i.count = 0;
                item.count = 1;
                setState(() {
                  complement.id = value;
                  checkMinAndMaxItens();
                });
              }),
        if (!complement.onlyOne)
          CountNumberInput(
            value: item.count,
            compactIfZero: true,
            max: complement.max == null
                ? null
                : complement.max! - countItens + item.count,
            onChanged: (v) {
              item.count = v;
              setState(checkMinAndMaxItens);
            },
          ),
      ]),
    );
  }

  void checkMinAndMaxItens() {
    enableAdd = true;
    total = widget.product.price;
    for (var c in widget.product.complements) {
      int countItens = 0;
      int priceItens = 0;
      for (var i in c.itens) {
        countItens += i.count;
        priceItens += i.count * i.price;
      }
      if (countItens < (c.min ?? 0)) enableAdd = false;
      total += priceItens;
    }
    total *= widget.countProduct;
  }
}