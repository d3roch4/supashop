import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/pages/profile/profile_edit_personal_data.dart';
import 'package:supashop/pages/store/list_stores_admin_page.dart';
import 'package:supashop/pages/store/store_form_page.dart';
import 'package:supashop/pages/store/store_manager_page.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/select_locale.dart';

class ProfilePage extends StatelessWidget {
  static var routePath = '/profile';
  AuthenticationService authService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildImageAvatar().marginOnly(left: 16),
        leadingWidth: 56,
        title: Text(authService.currentAccount!.name),
      ),
      body: ListView(children: [
        SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.person_outlined),
          title: Text('Personal data'.tr),
          subtitle: Text('Edit your personal data'.tr),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Get.to(() => ProfileEditPersonalData()),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.store_outlined),
          title: Text('My store'.tr),
          // subtitle: Text('Stores you manage'.tr),
          trailing: Icon(Icons.chevron_right),
          onTap: openMyStoreManager,
        ),
        Divider(),
        if (authService.currentAccount?.isAdmin == true)
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Manager stores'.tr),
            subtitle: Text('Administrative management'.tr),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Get.to(() => ListStoresAdminPage()),
          ),
        if (authService.currentAccount?.isAdmin == true) Divider(),
        // ListTile(
        //   leading: Icon(Icons.pin_drop_outlined),
        //   title: Text('Address'.tr),
        //   subtitle: Text('Edit your address'.tr),
        //   trailing: Icon(Icons.chevron_right),
        //   onTap: () => Get.to(() => AddressListPage()),
        // ),
        // Divider(),
        // ListTile(
        //   leading: Icon(Icons.credit_card),
        //   title: Text('Payment method'.tr),
        //   subtitle: Text('Add or edit payment methods'.tr),
        //   trailing: Icon(Icons.chevron_right),
        //   onTap: () => Get.to(() => PaymentMethodManagerPage()),
        // ),
        // Divider(),
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text('Exit of account'.tr),
          trailing: Icon(Icons.chevron_right),
          onTap: logout,
        ),
        Divider(),
        if (kDebugMode) SelectLocale().paddingAll(kPadding),
      ]),
    );
  }

  Widget buildImageAvatar() => CircleAvatar(
        backgroundColor: Colors.grey,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: authService.currentAccount?.image != null
              ? Image.network(
                  authService.currentAccount!.image!,
                  height: 56,
                  fit: BoxFit.fitHeight,
                )
              : Icon(
                  Icons.person_outlined,
                ),
        ),
      );

  void logout() {
    authService.logout();
    Get.offAllNamed('/');
  }

  Future<void> openMyStoreManager() async {
    StoreRepository storeRepository = Get.find();
    late Widget page;

    if (authService.currentAccount == null) {
      page = LoginPage();
    } else {
      var myStore = await storeRepository.getMyStore();

      if (myStore == null)
        page = StoreFormPage(Store(
          name: '',
          image: '',
          coverImage: '',
          description: '',
          documentNumber: '',
          phone: '',
          address: Address(),
        ));
      else
        page = StoreManager(store: myStore!);

      Get.to(() => page);
    }
  }
}