import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/util/location.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/address_form_field.dart';

class LocationChangeButton extends StatelessWidget {
  Future<Address> address;
  ValueChanged<Address> changed;

  LocationChangeButton({required this.changed, required this.address});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: kPadding)),
      onPressed: change,
      icon: Icon(Icons.my_location, color: Colors.grey, size: 24),
      label: FutureBuilder<Address>(
        future: address,
        builder: (context, snap) {
          if (snap.data == null)
            return SizedBox(
              width: 200,
              child: SkeletonLine(),
            );
          Address address = snap.data!;
          return Text(address.toString().tr,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis);
        },
      ),
    );
  }

  void change() {
    Get.dialog(AlertDialog(
      title: Text('Change location'.tr),
      content: AddressFormField(
        changed: saveLocation,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'.tr),
        ),
        TextButton(
          onPressed: () async =>
              saveLocation(await getCurrentAddressFromUser()),
          child: Text('Use current location'.tr),
        ),
      ],
    ));
  }

  void saveLocation(Address address) {
    Get.back();
    saveLastLocation(address);
    changed(address);
  }
}