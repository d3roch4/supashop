import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/model/search_result_item.dart';
import 'package:supashop/repository/product_repository.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Iterable<SearchResultItem> searchResults = <SearchResultItem>[];
  ProductRepository productRepository = Get.find();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: query,
          onChanged: (value) => query = value,
          onEditingComplete: () => search(),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search'.tr,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: search,
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (c, i) {
            var item = searchResults.elementAt(i);
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              leading: CachedNetworkImage(imageUrl: item.image, width: 60),
              onTap: () => openItem(item),
            );
          }),
    );
  }

  Future<void> search() async {
    searchResults = await productRepository.searchProducts(query);
    setState(() {});
  }

  void openItem(SearchResultItem item) {
    switch (item.type) {
      case SearchResultItemType.product:
        Get.toNamed('/product/${item.id}');
        break;
      case SearchResultItemType.store:
        Get.toNamed('/store/${item.id}');
        break;
      case SearchResultItemType.category:
        Get.toNamed('/category/${item.id}');
        break;
    }
  }
}