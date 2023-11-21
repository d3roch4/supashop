import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart' as geocode;
import 'package:get/get.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:location/location.dart';
import 'package:supashop/entities/address.dart';
import 'package:synchronized/synchronized.dart';

import 'local_storage/local_storage.dart';

var lock = new Lock();

void saveLastLocation(Address address) async {
  var localStorage = Get.find<LocalStorage>();
  await localStorage.write('last-location', jsonEncode(address.toJson()));
}

Future<Address> getLastLocation() async {
  var localStorage = Get.find<LocalStorage>();
  var last = await localStorage.read<String>('last-location');
  if (last != null) {
    var address = Address.fromJson(jsonDecode(last));
    return address;
  }

  var address = Address(
    street: 'Praça da Se',
    city: 'São Paulo',
    latitude: -29.549326,
    longitude: -49.893932,
    state: 'SP',
  );
  return address;
}

Future<Address> getCurrentAddressFromUser() async {
  var address = await getLastLocation();

  try {
    var geoCode = geocode.GeoCode();
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      if (!GetPlatform.isMacOS)
        _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return address;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return address;
      }
    }

    var locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null)
      return address;
    address.latitude = locationData.latitude;
    address.longitude = locationData.longitude;

    var result = await geoCode.reverseGeocoding(
        latitude: locationData.latitude!, longitude: locationData.longitude!);
    debugPrint(result.toString());
    address.street = result.streetAddress;
    address.number = result.streetNumber.toString();
    address.city = result.city;
    address.state = result.region;
  } catch (ex, st) {
    debugPrintStack(stackTrace: st, label: ex.toString());
  }

  return address;
}

Address predictionToAddress(Prediction prediction) {
  var address = Address(
    latitude: double.parse(prediction.lat ?? '0'),
    longitude: double.parse(prediction.lng ?? '0'),
    type: AddressType.other,
    neighborhood: prediction.placeDetails?.result?.addressComponents
        ?.firstWhereOrNull(
            (e) => e.types?.contains('administrative_area_level_1') ?? false)
        ?.shortName,
    city: prediction.placeDetails?.result?.addressComponents
        ?.firstWhereOrNull(
            (e) => e.types?.contains('administrative_area_level_2') ?? false)
        ?.shortName,
    street: prediction.placeDetails?.result?.addressComponents
        ?.firstWhereOrNull((e) => e.types?.contains('route') ?? false)
        ?.longName,
    number: prediction.placeDetails?.result?.addressComponents
        ?.firstWhereOrNull((e) => e.types?.contains('street_number') ?? false)
        ?.shortName,
    zipCode: prediction.placeDetails?.result?.addressComponents
        ?.firstWhereOrNull((e) => e.types?.contains('postal_code') ?? false)
        ?.longName,
  );

  return address;
}