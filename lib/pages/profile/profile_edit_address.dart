import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/repository/address_repository.dart';
import 'package:supashop/util/next_focus.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/util/via_cep_api.dart';

class ProfileEditAddress extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  Timer? timer;
  var viaCepApi = ViaCepApi();
  var streetName = TextEditingController();
  var number = TextEditingController();
  var complement = TextEditingController();
  var neighborhood = TextEditingController();
  var city = TextEditingController();
  var zipCode = TextEditingController();
  var focusNumber = FocusNode();
  Address address;
  AddressRepository repository = Get.find();

  ProfileEditAddress({super.key, required this.address}) {
    zipCode.text = address.zipCode ?? '';
    streetName.text = address.street ?? '';
    number.text = address.number ?? '';
    complement.text = address.complement ?? '';
    neighborhood.text = address.neighborhood ?? '';
    city.text = address.city ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit your address')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: zipCode,
              decoration: InputDecoration(labelText: 'Zip code'.tr),
              maxLines: 1,
              onEditingComplete: nextFocusEditingComplete,
              onChanged: findCep,
              validator: defaultValidator,
            ).paddingOnly(bottom: 16),
            TextFormField(
              controller: streetName,
              decoration: InputDecoration(labelText: 'Street name'.tr),
              maxLines: 1,
              validator: defaultValidator,
              onEditingComplete: nextFocusEditingComplete,
            ).paddingOnly(bottom: 16),
            Row(children: [
              Container(
                  width: 100,
                  padding: EdgeInsets.only(right: 8),
                  child: TextFormField(
                    controller: number,
                    decoration: InputDecoration(labelText: 'Number'.tr),
                    maxLines: 1,
                    onEditingComplete: nextFocusEditingComplete,
                    focusNode: focusNumber,
                  )),
              Expanded(
                  child: TextFormField(
                controller: complement,
                decoration: InputDecoration(labelText: 'Complement'.tr),
                maxLines: 1,
                onEditingComplete: nextFocusEditingComplete,
              )),
            ]).paddingOnly(bottom: 16),
            TextFormField(
              controller: neighborhood,
              decoration: InputDecoration(labelText: 'Neighborhood'.tr),
              maxLines: 1,
              validator: defaultValidator,
              onEditingComplete: nextFocusEditingComplete,
            ).paddingOnly(bottom: 16),
            TextFormField(
              controller: city,
              decoration: InputDecoration(labelText: 'City'.tr),
              maxLines: 1,
              validator: defaultValidator,
              onEditingComplete: nextFocusEditingComplete,
            ).paddingOnly(bottom: 16),
          ],
        ),
      ),
      bottomNavigationBar:
          ElevatedButton(child: Text('Save'.tr), onPressed: save)
              .paddingAll(16),
    );
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    address.zipCode = zipCode.text;
    address.street = streetName.text;
    address.number = number.text;
    address.complement = complement.text;
    address.neighborhood = neighborhood.text;
    address.city = city.text;
    await repository.saveAddress(address);
    Get.back();
  }

  void findCep(String cep) {
    timer?.cancel();
    timer = Timer(Duration(seconds: 1), () async {
      var result = await viaCepApi.find(cep);
      if (result == null) return;
      streetName.text = result.logradouro;
      city.text = '${result.localidade}, ${result.uf}';
      complement.text = result.complemento;
      neighborhood.text = result.bairro;
      zipCode.text = result.cep;
      focusNumber.requestFocus();
    });
  }
}