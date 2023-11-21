import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/store.dart';

abstract class StoreRepository {
  Future<Iterable<Store>> getStoresListByAddress(
      Address address, int pageKey, int pageSize);

  Future<Store?> getStoreByIdWithProducts(String establishmentId);

  Future<Store?> getMyStore();

  Future<Store> saveStore(Store establishment);

  Future<Iterable<Store>> getAllStores();

  Future<void> saveActiveStatus(String id, bool bool);

  Future<StoreSetup> getStoreSetup(String storeId);

  Future<void> saveStoreSetup(StoreSetup setup);
}