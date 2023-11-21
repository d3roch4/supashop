import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortuid/shortuid.dart';
import 'package:supashop/entities/order.dart';
import 'package:supashop/pages/main_page.dart';
import 'package:supashop/widgets/payment_method_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entities/i_order.dart';
import '../../util/util.dart';

class TrackOrderPage extends StatelessWidget {
  Order order;
  bool backToHome = true;

  TrackOrderPage(this.order, {this.backToHome = true});

  @override
  Widget build(BuildContext context) {
    var deliveryTime =
        order.estimatedDeliveryTime.map((e) => DateTime.now().add(e));
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: goBack),
        actions: [
          TextButton.icon(
            onPressed: help,
            icon: Icon(Icons.question_answer),
            label: Text('Help'.tr),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(kPadding),
        children: [
          Text("Delivery forecast".tr),
          Text('Today, %s'.trArgs(
              [deliveryTime.map((e) => timeFormat.format(e)).join(' - ')])),
          LinearProgressIndicator(
            value: OrderStatus.values.indexOf(order.status) /
                (OrderStatus.values.length - 2),
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(height: 16),
          buildCardDetail(),
          SizedBox(height: 16),
          if (order.address != null)
            Text(
              'Address of delivery'.tr,
            ),
          if (order.address != null)
            Text(
              order.address.toString(),
            ),
          SizedBox(height: 16),
          Chip(
            label: Text(
              'Delivery made by the establishment'.tr,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget buildCardDetail() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color: Color(0xFFE9EBEE)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Order details'.tr,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    image: order.store.image == null
                        ? null
                        : DecorationImage(
                            image:
                                CachedNetworkImageProvider(order.store.image!),
                            fit: BoxFit.fill,
                          ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    order.store.name,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Order Nº %s'
                                .trArgs([ShortUid.from_uid(order.id!)]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentMethodView(
                  paymentMethod: order.paymentMethod,
                  inline: true,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Total'.tr),
                      Text(
                        currencyFormat.format(order.total / 100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(),
          TextButton(
            onPressed: callToEstablishment,
            child: Row(children: [
              Expanded(
                  child: Text(
                'Call to establishment'.tr,
                overflow: TextOverflow.ellipsis,
              )),
              Icon(Icons.phone)
            ]),
          ),
        ],
      ),
    );
  }

  void help() {
    var phone = order.store.phone.replaceAll(RegExp(r'\D'), '');
    launchUrl(Uri.parse('https://wa.me/$phone'));
  }

  void callToEstablishment() {
    var phone = order.store.phone.replaceAll(RegExp(r'\D'), '');
    launchUrl(Uri.parse('tel:$phone'));
  }

  void goBack() {
    if (backToHome)
      Get.offNamed(MainPage.routePath);
    else
      Get.back();
  }
}