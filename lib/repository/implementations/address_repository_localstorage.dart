import 'dart:convert';

import 'package:get/get.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/repository/address_repository.dart';
import 'package:supashop/util/local_storage/local_storage.dart';

class AddressRepositoryLocalstorage extends AddressRepository {
  LocalStorage localStorage = Get.find();

  @override
  Future<List<Address>> getAllAddresses() async {
    var storaged = await localStorage.read<String>('addresses');
    if (storaged == null) return [];
    var addresses = jsonDecode(storaged) as List;
    return addresses.map<Address>((e) => Address.fromJson(e)).toList();
  }

  @override
  Future<Address?> getLastUsedAddress() {
    return getAllAddresses().then((value) => value.firstOrNull);
  }

  @override
  Future saveAddress(Address address) {
    return getAllAddresses().then((value) {
      value.insert(0, address);
      return localStorage.write('addresses', jsonEncode(value));
    });
  }
}