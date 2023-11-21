import 'package:supashop/entities/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAllAddresses();

  Future<Address?> getLastUsedAddress();

  Future saveAddress(Address address);
}