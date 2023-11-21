import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:google_search_place/model/prediction.dart';

import '../entities/address.dart';
import '../util/location.dart';
import '../util/util.dart';

class AddressFormField extends StatelessWidget {
  var searchPlaceController = TextEditingController();
  ValueChanged<Address> changed;
  FormFieldValidator<Address>? validator;
  Address? initalValue;

  AddressFormField({required this.changed, this.validator, this.initalValue}) {
    searchPlaceController.text = initalValue?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SearchPlaceAutoCompletedTextField(
      inputDecoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Address and number'.tr,
      ),
      googleAPIKey: kGoogleApiKey,
      controller: searchPlaceController,
      validator: validator == null ? null : (value) => validator!(initalValue),
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
        changed(predictionToAddress(prediction));
      },
    );
  }
}