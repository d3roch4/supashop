import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supashop/entities/order.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/pages/order/tack_order_by_store_page.dart';
import 'package:supashop/pages/product/poduct_form_page.dart';
import 'package:supashop/pages/store/store_form_page.dart';
import 'package:supashop/pages/store/store_setup_form_page.dart';
import 'package:supashop/repository/order_repository.dart';
import 'package:supashop/repository/product_repository.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/back_button_blur.dart';
import 'package:supashop/widgets/classification_view.dart';
import 'package:supashop/widgets/error_message_widget.dart';
import 'package:supashop/widgets/image_cover_and_logo_establishment.dart';

class StoreManager extends StatefulWidget {
  static var routePath = '/establishment/manage';
  Store store;

  StoreManager({required this.store});

  @override
  State<StoreManager> createState() => _StoreManagerState();
}

class _StoreManagerState extends State<StoreManager> {
  StoreRepository establishmentRepository = Get.find();
  ProductRepository productRepository = Get.find();
  OrderRepository orderRepository = Get.find();
  bool _showFab = true;
  var duration = Duration(milliseconds: 300);
  Iterable<Product> products = <Product>[];
  late Future<Iterable<Product>> productsFuture;
  late NumberFormat currencyFormat;

  @override
  void initState() {
    productsFuture = productRepository.getProductsByStore(widget.store);
    currencyFormat = NumberFormat.simpleCurrency(
      locale: localeSelected.value.toLanguageTag(),
      name: widget.store.currency,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DefaultTabController(
            length: 2,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                ScrollDirection direction = notification.direction;
                setState(() {
                  if (direction == ScrollDirection.reverse) {
                    _showFab = false;
                  } else if (direction == ScrollDirection.forward) {
                    _showFab = true;
                  }
                });
                return true;
              },
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 300.0,
                    leading: BackButtonBlur(),
                    actions: [
                      IconButton(
                          onPressed: () => editEstablishment(widget.store),
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () => Get.to(
                              () => StoreSetupFormPage(store: widget.store)),
                          icon: Icon(Icons.admin_panel_settings))
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      title: Text(
                        widget.store.name,
                        style: Get.theme.appBarTheme.titleTextStyle,
                      ),
                      background: ImageCoverAndLogoEstablhishment(widget.store,
                          height: 240),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(TabBar(
                      tabs: [
                        Tab(text: 'Catalog'.tr),
                        Tab(text: 'Sales'.tr),
                      ],
                    )),
                    pinned: true,
                  ),
                ],
                body: TabBarView(
                  children: [
                    bodyCatalogList(),
                    buildSalesList(),
                  ],
                ),
              ),
            )));
  }

  Widget buildInfor(Store establishment) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(establishment.description),
      ClassificationView(establishment.classification)
    ]).paddingSymmetric(horizontal: kPadding);
  }

  Future<void> editEstablishment(Store establishment) async {
    await Get.to(() => StoreFormPage(establishment));
    setState(() {});
  }

  Future<void> openProductFormPage([Product? product]) async {
    await Get.to(() => ProductFormPage(widget.store, product));
    setState(() {
      productsFuture = productRepository.getProductsByStore(widget.store);
    });
  }

  Widget bodyCatalogList() {
    return FutureBuilder(
        future: productsFuture,
        initialData: products,
        builder: (c, snap) {
          if (snap.hasError)
            return ErrorMessageWidget(snap.error.toString(), snap.stackTrace);
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          products = snap.data!;
          return Scaffold(
            body: ListView.builder(
              itemBuilder: (c, index) {
                var product = products.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(product.images.first)),
                  title: Text(product.name),
                  subtitle: Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(currencyFormat.format(product.price / 100)),
                  onTap: () => openProductFormPage(product),
                );
              },
              itemCount: products.length,
            ),
            floatingActionButton: AnimatedSlide(
              duration: duration,
              offset: _showFab ? Offset.zero : Offset(0, 2),
              child: AnimatedOpacity(
                duration: duration,
                opacity: _showFab ? 1 : 0,
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.add),
                  label: Text('Add product'.tr),
                  onPressed: openProductFormPage,
                ),
              ),
            ),
          );
        });
  }

  Widget buildSalesList() {
    return StreamBuilder(
      stream: orderRepository.getOrdersByStore(widget.store),
      builder: (c, snap) {
        if (snap.hasError)
          return ErrorMessageWidget(snap.error.toString(), snap.stackTrace);
        if (!snap.hasData) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemBuilder: (c, index) {
            var order = snap.data!.elementAt(index);
            return ListTile(
              leading: order.user.image == null
                  ? Icon(Icons.person)
                  : CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(order.user.image!)),
              title: Text(order.user.name),
              subtitle: Text(
                '${order.status.name} ${order.address?.toString() ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(children: [
                Text(currencyFormat.format(order.total / 100)),
                Text(dateTimeFormat.format(order.createdAt)),
              ]),
              onTap: () => openOrder(order),
            );
          },
          itemCount: snap.data!.length,
        );
      },
    );
  }

  void openOrder(Order order) {
    Get.to(() => TrackOrderByStorePage(order));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}