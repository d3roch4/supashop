import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/pages/profile/profile_edit_address.dart';

class AddressListPage extends StatelessWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Address list'.tr)),
      body: ListView(children: [
        ListTile(
          title: Text('Now location'.tr),
          subtitle: Text('Use you now location'.tr),
          leading: Icon(Icons.pin_drop_outlined),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Get.to(() {}),
        ),
        Divider(),
        ListTile(
          title: Text('House'.tr),
          subtitle: Text('Edit addres of you house'.tr),
          trailing: Icon(Icons.chevron_right),
          leading: Icon(Icons.home),
          onTap: () => Get.to(() => ProfileEditAddress(
                address: Address(),
              )),
        ),
        Divider(),
        ListTile(
          title: Text('Work'.tr),
          subtitle: Text('Edit addres of you work'.tr),
          trailing: Icon(Icons.chevron_right),
          leading: Icon(Icons.work),
          onTap: () => Get.to(() => ProfileEditAddress(
                address: Address(),
              )),
        ),
      ]),
    );
  }
}