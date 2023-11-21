import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/model/search_result_item.dart';
import 'package:supashop/repository/product_repository.dart';

import 'storage_supabase_util.dart';

class ProductRepositorySupabase extends ProductRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<FutureOr<void>> saveProduct(Product product) async {
    for (var i = 0; i < product.images.length; i++) {
      if (product.images[i].isEmpty) continue;
      if (!product.images[i].startsWith('http')) {
        product.images[i] = await StorageSupabaseUtil.saveImage(
            supabase, product.images[i], product.storeId, 'products');
      }
    }
    var json = product.toJson();
    json['images'] = (product.images..removeWhere((e) => e.isEmpty)).join(',');
    json.remove('category_ids');
    await supabase.from('products').upsert(json);
  }

  @override
  Future<Iterable<Product>> getProductsByStore(Store store) {
    return supabase.from('products').select().eq('store_id', store.id).then(
        (value) => value.map<Product>((e) => Product.fromJson(e)).toList());
  }

  @override
  Future<Product?> getProductById(String productId) async {
    var result = await supabase.from('products').select().eq('id', productId);
    return Product.fromJson(result.first);
  }

  @override
  Future<Iterable<SearchResultItem>> searchProducts(String query) async {
    var result = await supabase
        .from('products')
        .select('id, name, description, images')
        .textSearch('fts', query,
            type: TextSearchType.websearch, config: 'portuguese') as List;
    return result.map<SearchResultItem>((e) => SearchResultItem(
        type: SearchResultItemType.product,
        id: e['id'],
        title: e['name'],
        subtitle: e['description'],
        image: e['images'].split(',')[0]));
  }
}