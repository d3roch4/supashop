import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/repository/profile_repository.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/util.dart';

class ProfileEditPersonalData extends StatelessWidget {
  Account account = Get.find<AuthenticationService>().currentAccount!;
  var profileRepository = Get.find<ProfileRepository>();
  var fullname = TextEditingController();
  var documentNumber = TextEditingController();
  var formKey = GlobalKey<FormState>();

  ProfileEditPersonalData() {
    initControllers();
    profileRepository.getMyProfile().then((value) {
      account = value;
      initControllers();
    });
  }

  void initControllers() {
    fullname.text = account.name;
    documentNumber.text = account.documentNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var titleStyle = Get.textTheme.titleSmall;

    return Scaffold(
      appBar: AppBar(title: Text('Edit personal data'.tr)),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(kPadding),
          children: [
            Text("Access data".tr, style: titleStyle),
            // Chip(
            //   label: Text('This data cannot be changed'),
            // ).paddingSymmetric(vertical: 16),
            fixedInfor('Email:', account.email),
            if (account.phone != null) fixedInfor('Phone:'.tr, account.phone!),
            Text('Personal data'.tr, style: titleStyle).paddingOnly(top: 40),
            TextFormField(
              controller: fullname,
              decoration: InputDecoration(
                labelText: 'Fullname'.tr,
                hintText: 'Type your name'.tr,
              ),
              validator: fullNameValidator,
              keyboardType: TextInputType.name,
            ).paddingOnly(bottom: 16),
            TextFormField(
              controller: documentNumber,
              decoration: InputDecoration(
                labelText: 'Document number'.tr,
                hintText: '(Optional) Type your document number'.tr,
              ),
              keyboardType: TextInputType.name,
              inputFormatters: [
                if (Get.locale?.countryCode == 'BR')
                  MaskTextInputFormatter(
                    mask: "###.###.###-##",
                    filter: {"#": RegExp(r'[0-9]')},
                  )
              ],
            ).paddingOnly(top: 16)
          ],
        ),
      ),
      bottomNavigationBar:
          ElevatedButton(child: Text('Save'.tr), onPressed: save)
              .paddingAll(16),
    );
  }

  Widget fixedInfor(String label, String info) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(info)]);

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    account.name = fullname.text;
    account.documentNumber = documentNumber.text;
    await profileRepository.save(account);
    Get.back();
  }
}