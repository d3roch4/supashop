import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/pages/main_page.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/util/currency_input_format.dart';
import 'package:supashop/util/location.dart';
import 'package:supashop/widgets/documents_picker.dart';

import '../../util/util.dart';

class StoreFormPage extends StatelessWidget {
  Store store;
  var formKey = GlobalKey<FormState>();
  FileDocument? image;
  FileDocument? coverImage;
  StoreRepository repository = Get.find();
  var searchPlaceController = TextEditingController();
  Address address;

  StoreFormPage(this.store, {super.key}) : address = store.address {
    searchPlaceController.text = address.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit your establishment information'.tr)),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(kPadding),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'.tr),
              initialValue: store.name,
              validator: defaultValidator,
              onSaved: (value) => store.name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'.tr),
              initialValue: store.description,
              validator: defaultValidator,
              onSaved: (value) => store.description = value!,
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Identification number'.tr),
              initialValue: store.documentNumber,
              onSaved: (value) => store.documentNumber = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone'.tr),
              initialValue: store.phone,
              validator: defaultValidator,
              onSaved: (value) => store.phone = value!,
            ),
            SearchPlaceAutoCompletedTextField(
              inputDecoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: 'Address and number'.tr,
              ),
              googleAPIKey: kGoogleApiKey,
              controller: searchPlaceController,
              itmOnTap: (Prediction prediction) {
                searchPlaceController.text = prediction.description ?? "";
                searchPlaceController.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0));
              },
              getPlaceDetailWithLatLng: (Prediction prediction) {
                searchPlaceController.text = prediction.description ?? "";
                searchPlaceController.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0));
                debugPrint("${prediction.lat} ${prediction.lng}");
                address = predictionToAddress(prediction);
              },
              validator: (_) => address.type == AddressType.unknown
                  ? 'This field is requerid'.tr
                  : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Delivery fee'.tr,
              ),
              initialValue: currencyFormat.format(store.deliveryFee / 100),
              validator: defaultValidator,
              onSaved: (value) => store.deliveryFee =
                  (currencyFormat.parse(value!) * 100).toInt(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(currencyFormat),
              ],
            ),
            SizedBox(height: kPadding),
            Text('Logo'.tr),
            DocumentsPickerViewer(
              addLabel: 'Add logo'.tr,
              multplesFile: false,
              urls: [store.image],
              onChange: (value) => image = value.firstOrNull,
            ),
            Text('Cover image'.tr),
            DocumentsPickerViewer(
              addLabel: 'Add cover image'.tr,
              multplesFile: false,
              urls: [store.coverImage],
              onChange: (value) => coverImage = value.firstOrNull,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: save,
        child: Text('Save'.tr),
      ).paddingAll(kPadding),
    );
  }

  save() async {
    if ((image == null && !store.image.startsWith('http')) ||
        (coverImage == null && !store.coverImage.startsWith('http'))) {
      return ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('You need to select the images'.tr)));
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (image != null) store.image = image!.path!;
      if (coverImage != null) store.coverImage = coverImage!.path!;
      store.address = address;
      var result = await repository.saveStore(store);
      Get.off(MainPage(selectedTab: 1));
    }
  }
}