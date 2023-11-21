import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/pages/store/store_manager_page.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/util/global_values.dart';
import 'package:supashop/widgets/list_tile_store.dart';
import 'package:supashop/widgets/loadding_widget.dart';

class ListStoresAdminPage extends StatelessWidget {
  StoreRepository storeRepository = Get.find();

  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: kPadding);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager stores'.tr),
      ),
      body: LoaddingWidget.future(
        future: storeRepository.getAllStores(),
        builder: (list) => ListView.separated(
          itemBuilder: (c, i) => ListTileStore(
            list.elementAt(i),
            padding: padding,
            onTap: (item) => Get.to(() => StoreManager(store: item)),
          ),
          separatorBuilder: (c, i) => Divider(),
          itemCount: list!.length,
        ),
      ),
    );
  }
}