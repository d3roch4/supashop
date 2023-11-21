import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/product_category.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/repository/product_repository.dart';
import 'package:supashop/repository/store_repository.dart';

import 'storage_supabase_util.dart';

class StoreRepositorySupabase extends StoreRepository {
  final supabase = Supabase.instance.client;
  ProductRepository productRepository = Get.find();
  static const tableName = 'stores';

  StoreRepositorySupabase() {
    // supabase.storage.setAuth(supabase.auth.currentSession!.accessToken);
  }

  @override
  Future<Store?> getStoreByIdWithProducts(String establishmentId) async {
    List data =
        await supabase.from(tableName).select().eq('id', establishmentId);
    if (data.isEmpty) return null;
    var store = Store.fromJson(data.first);
    var products = await productRepository.getProductsByStore(store);
    // var categoryIds = products.map((e) => e.categoryIds).toList().fold<List<String>>(<String>[],
    //         (initialValue, pageItems) => initialValue..addAll(pageItems));
    store.categories = [ProductCategory(name: '', products: products)];
    return store;
  }

  @override
  Future<Iterable<Store>> getStoresListByAddress(
      Address address, int pageKey, int pageSize) async {
    final data = await supabase.rpc('list_stores', params: {
      'lat': address.latitude,
      'long': address.longitude,
      'size': pageSize,
      'page': pageKey,
    });

    return data.map<Store>((e) => Store.fromJson(e));
  }

  @override
  Future<Store?> getMyStore() async {
    if (supabase.auth.currentUser == null) return null;
    List data = await supabase
        .from(tableName)
        .select()
        .eq('user_id', supabase.auth.currentUser?.id);
    if (data.isEmpty) return null;
    return Store.fromJson(data.first);
  }

  @override
  Future<Store> saveStore(Store store) async {
    if (!store.image.startsWith('http')) {
      store.image =
          await StorageSupabaseUtil.saveImage(supabase, store.image, store.id!);
    }
    if (!store.coverImage.startsWith('http')) {
      store.coverImage = await StorageSupabaseUtil.saveImage(
          supabase, store.coverImage, store.id!);
    }

    var json = store.toJson();
    json['location'] =
        'POINT(${store.address.longitude} ${store.address.latitude})';
    json.remove('categories');
    json.remove('category');
    json.remove('openingHours');
    json.remove('tags');
    json['user_id'] = supabase.auth.currentUser!.id;
    await supabase.from(tableName).upsert(json);
    return store;
  }

  @override
  Future<Iterable<Store>> getAllStores() async {
    var list = await supabase.from(tableName).select() as List;
    return list.map<Store>((e) => Store.fromJson(e));
  }

  @override
  Future<void> saveActiveStatus(String id, bool active) async {
    await supabase.from(tableName).update({'activated': active}).eq('id', id);
  }

  @override
  Future<StoreSetup> getStoreSetup(String storeId) async {
    var data = await supabase
        .from('store_setup')
        .select()
        .eq('store_id', storeId)
        .single();
    return StoreSetup.fromJson(data ?? {'store_id': storeId});
  }

  @override
  Future<void> saveStoreSetup(StoreSetup setup) {
    return supabase.from('store_setup').upsert(setup.toJson());
  }
}