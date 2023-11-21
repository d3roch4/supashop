import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/cart.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/product_category.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/pages/cart/cart_page.dart';
import 'package:supashop/pages/error_page.dart';
import 'package:supashop/pages/product/product_view_page.dart';
import 'package:supashop/pages/store/store_detail_view_page.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/back_button_blur.dart';
import 'package:supashop/widgets/classification_view.dart';
import 'package:supashop/widgets/image_cover_and_logo_establishment.dart';
import 'package:supashop/widgets/product_list_tile.dart';

class EstablishmentViewPage extends StatelessWidget {
  static var routePath = '/establishment/:id';
  Store store;
  var styleCategory = Get.textTheme.labelSmall;
  var categories = <ProductCategory>[].obs;
  var cart = Rx<Cart?>(null);
  CartRepository cartRepository = Get.find();
  late Future<Store?> storeFuture;

  EstablishmentViewPage([Store? establishment])
      : store = establishment ?? Get.arguments {
    categories.value = this.store.categories;
    checkOpenCart();
    storeFuture =
        Get.find<StoreRepository>().getStoreByIdWithProducts(this.store.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: store,
      future: storeFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return ErrorPage(
              message: snapshot.error.toString(),
              stackTrace: snapshot.stackTrace);

        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        store = snapshot.data as Store;
        categories.value = store.categories;
        return Scaffold(
          body: ListView(children: [
            Stack(children: [
              ImageCoverAndLogoEstablhishment(store),
              Positioned(top: 16, left: 16, child: BackButtonBlur()),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.name,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                  ClassificationView(store.classification),
                ],
              ),
              Text(store.description, style: Get.textTheme.labelSmall),
              buildButtonStoreDetail(),
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search for establishment items'.tr),
                onChanged: search,
              )
            ]).paddingAll(16),
            Obx(() => Column(children: [
                  for (var category in categories.value)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(category.name, style: styleCategory),
                            for (var product in category.products)
                              ProductListTile(product, openProduct)
                                  .paddingOnly(bottom: 24),
                          ]),
                    ),
                ]))
          ]),
          bottomNavigationBar: buildBottonBar(),
        );
      },
    );
  }

  Widget buildAppBar() {
    final titleTop = 60.0;
    final expandedHeight = (Get.width * 9 / 16) + titleTop;

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        final fraction = max(0, constraints.biggest.height - kToolbarHeight) /
            (expandedHeight - kToolbarHeight);
        return FlexibleSpaceBar(
          title: Padding(
            padding: EdgeInsets.only(right: 8, left: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    store.name,
                    maxLines: 1,
                    textAlign:
                        fraction >= 1 ? TextAlign.left : TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (fraction >= 1) ClassificationView(store.classification),
              ],
            ),
          ),
          background: ImageCoverAndLogoEstablhishment(store, height: 240),
        );
      }),
    );
  }

  void search(String value) {
    if (value.isEmpty) {
      categories.value = store.categories;
      return;
    }
    value = value.toLowerCase();
    var newList = <Product>[];
    for (var category in store.categories) {
      newList.addAll(
          category.products.where((e) => e.name.toLowerCase().contains(value)));
    }
    categories.value = [
      ProductCategory(
        name: 'Search result'.tr,
        image: '',
        products: newList,
      )
    ];
  }

  void openProduct(Product product) {
    product.storeId = store.id ?? '';
    Get.toNamed(ProductViewPage.routePath, arguments: product);
  }

  Widget buildBackButton() {
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
        // begin: Alignment.topLeft,
        // end: Alignment.bottomRight,
        stops: [
          0,
          0.5,
        ],
        colors: [
          Colors.white,
          Colors.white,
        ],
      ))),
      Positioned(
        child: BackButton(),
        bottom: 0,
        left: 16,
      ),
    ]);
  }

  void checkOpenCart() async {
    cart.bindStream(cartRepository.getIfExistCartByEstablishment(store));
  }

  void gotoCart() {
    Get.to(() => CartPage(cart: cart.value!));
  }

  Widget buildBottonBar() {
    return Obx(() => cart.value != null
        ? Container(
            padding: EdgeInsets.all(kPadding),
            // decoration: BoxDecoration(border: Border()),
            child: ElevatedButton(
                child: Text('Go to cart'.tr), onPressed: gotoCart),
          )
        : SizedBox());
  }

  Widget buildButtonStoreDetail() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () => Get.to(() => EstablishmentDetailViewPage(
                establishment: store,
              )),
          child: Text(
            'Store profile'.tr,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}