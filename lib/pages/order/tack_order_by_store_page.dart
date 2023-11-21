import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supashop/entities/i_order.dart';
import 'package:supashop/entities/order.dart';
import 'package:supashop/repository/order_repository.dart';
import 'package:supashop/util/util.dart';

class TrackOrderByStorePage extends StatefulWidget {
  Order order;
  NumberFormat currencyFormat;

  TrackOrderByStorePage(this.order)
      : currencyFormat = NumberFormat.simpleCurrency(
            locale: localeSelected.value.toLanguageTag(),
            name: order.store.currency);

  @override
  State<TrackOrderByStorePage> createState() => _TrackOrderByStorePageState();
}

class _TrackOrderByStorePageState extends State<TrackOrderByStorePage> {
  OrderRepository orderRepository = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order tracking'.tr),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Cancel order'.tr), value: 'cancel'),
            ],
            onSelected: menuSelectItem,
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(kPadding),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(widget.order.user.name),
            subtitle: Text('${widget.order.user.phone}'),
            leading: widget.order.user.image == null
                ? Icon(Icons.person)
                : CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.order.user.image!),
                  ),
          ),
          Text('Address: %s'.trArgs([widget.order.address.toString()])),
          Divider(),
          for (var item in widget.order.items)
            ListTile(
              trailing: CachedNetworkImage(
                  imageUrl: item.product.images.first, width: 50),
              title: Text(item.product.name),
              subtitle: Text(widget.currencyFormat.format(item.total / 100)),
              leading: Text(item.quantity.toString()),
              contentPadding: EdgeInsets.zero,
            ),
          Divider(),
          Text(
              'Total order: %s'.trArgs(
                  [widget.currencyFormat.format(widget.order.total / 100)]),
              textAlign: TextAlign.right),
          Divider(),
          Text('Order code: %s'.trArgs([widget.order.id!])),
          Text('Status: %s'.trArgs([widget.order.status.name.tr])),
        ],
      ),
      bottomNavigationBar: getBottomActionStatus(),
    );
  }

  void menuSelectItem(String value) {
    switch (value) {
      case 'cancel':
        setStatus(OrderStatus.canceled);
        break;
    }
  }

  Future<void> setStatus(OrderStatus newStatus) async {
    await orderRepository.setStatus(widget.order, newStatus);
    setState(() {});
  }

  Widget? getBottomActionStatus() {
    if (widget.order.status == OrderStatus.waiting)
      return ElevatedButton(
        onPressed: () => setStatus(OrderStatus.inPreparation),
        child: Text('Accept order'.tr),
      ).paddingAll(kPadding);
    if (widget.order.status == OrderStatus.inPreparation)
      return ElevatedButton(
        onPressed: () => setStatus(OrderStatus.sending),
        child: Text(OrderStatus.sending.name.tr),
      ).paddingAll(kPadding);
    if (widget.order.status == OrderStatus.sending)
      return ElevatedButton(
        onPressed: () => setStatus(OrderStatus.delivered),
        child: Text(OrderStatus.delivered.name.tr),
      ).paddingAll(kPadding);
    return null;
  }
}