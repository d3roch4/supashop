import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/promotion_banner.dart';
import 'package:supashop/repository/promotion_banner_repository.dart';
import 'package:supashop/widgets/horizontal_list_async.dart';
import 'package:supashop/widgets/image_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionsBannersList extends StatelessWidget {
  late Future<Iterable<PromotionBanner>> itens;
  double width;
  double height;
  PromotionBannerRepository repository = Get.find();

  PromotionsBannersList({this.width = 267, this.height = 160}) {
    itens = repository.getAllBanner();
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalListAsync(
      heightSkeleton: height,
      widthSkeleton: width,
      itens: itens,
      itemBuilder: (banner) => ImageButton(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        onTap: () => openItem(banner),
        height: height,
        width: width,
        imageUrl: banner.image,
      ),
    );
  }

  void openItem(PromotionBanner banner) {
    launchUrl(Uri.parse(banner.redirectTo));
  }
}