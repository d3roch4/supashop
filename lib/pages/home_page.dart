import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/pages/store/store_view_page.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/location.dart';
import 'package:supashop/widgets/categories_list.dart';
import 'package:supashop/widgets/location_change_button.dart';
import 'package:supashop/widgets/store_list.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Account? user = Get.find<AuthenticationService>().currentAccount;
  late Future<Address> address;
  var listKey = GlobalKey<StoreListByAddressState>();

  @override
  void initState() {
    address = getCurrentAddressFromUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          addressAndNotificationBar(),
          CategoriesList(address: address),
          // PromotionsBannersList(),
        ]).paddingOnly(left: 16, right: 16)),
        StoreListByAddress(
            key: listKey,
            address: address,
            openItem: (item) =>
                Get.toNamed(EstablishmentViewPage.routePath, arguments: item)),
      ],
    );
  }

  void showNotifications() {}

  Widget addressAndNotificationBar() => LocationChangeButton(
        address: address,
        changed: (value) {
          address = Future.value(value);
          listKey.currentState!.refresh(address);
          setState(() {});
        },
      );
}