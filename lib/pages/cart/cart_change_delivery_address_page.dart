import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/repository/address_repository.dart';
import 'package:supashop/util/global_values.dart';
import 'package:supashop/util/location.dart';
import 'package:supashop/widgets/icon_address_type.dart';

class CartChangeDeliveryAddressPage extends StatelessWidget {
  Address? addressSelected;
  AddressRepository addressRepository = Get.find();
  final TextEditingController searchPlaceController = TextEditingController();

  CartChangeDeliveryAddressPage({this.addressSelected}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change delivery address'.tr),
      ),
      body: FutureBuilder(
          future: findAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var addressess = snapshot.data as List<Address>;
              return ListView(padding: EdgeInsets.all(16), children: [
                SearchPlaceAutoCompletedTextField(
                  inputDecoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Address and number'.tr,
                  ),
                  googleAPIKey: kGoogleApiKey,
                  controller: searchPlaceController,
                  itmOnTap: (Prediction prediction) {
                    searchPlaceController.text = prediction.description ?? "";
                    searchPlaceController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: prediction.description?.length ?? 0));
                  },
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    searchPlaceController.text = prediction.description ?? "";
                    searchPlaceController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: prediction.description?.length ?? 0));
                    debugPrint("${prediction.lat} ${prediction.lng}");
                    goBack(predictionToAddress(prediction));
                  },
                ),
                for (var address in addressess) buildCardAddress(address),
              ]);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildCardAddress(Address address) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${address.street}, ${address.number}'),
            if (addressSelected == address)
              Icon(
                Icons.check_circle_outline,
                size: 20,
              )
          ],
        ),
        subtitle: Text('${address.city} - ${address.state}'),
        leading: IconAddressType(type: address.type),
        onTap: () => goBack(address),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void goBack(Address address) {
    Get.back(result: address);
  }

  Future<List<Address>> findAddress() async {
    var addresses = await addressRepository.getAllAddresses();
    if (addressSelected != null && !addresses.contains(addressSelected))
      searchPlaceController.text = addressSelected.toString();
    return addresses;
  }
}