import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/repository/category_repository.dart';
import 'package:supashop/widgets/horizontal_list_async.dart';
import 'package:supashop/widgets/image_button.dart';
import 'package:supashop/widgets/snack_messages.dart';

import '../entities/product_category.dart';

class CategoriesList extends StatelessWidget {
  late Future<List<ProductCategory>> categories;
  double size;
  Future<Address> address;

  CategoriesList({this.size = 78, required this.address}) {
    categories = address.then((value) =>
        Get.find<CategoryRepository>().getCategoriesByAddress(value));
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalListAsync(
      heightSkeleton: size + 12 * 1.2,
      widthSkeleton: size,
      itens: categories,
      itemBuilder: (category) => ImageButton(
        onTap: () => openCategory(category),
        height: size,
        width: size,
        imageUrl: category.image ?? '',
        footer: Text(category.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }

  void openCategory(ProductCategory category) {
    snackInfo(category.name);
  }
}