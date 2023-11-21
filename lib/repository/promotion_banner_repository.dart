import 'package:supashop/entities/promotion_banner.dart';

abstract class PromotionBannerRepository {
  Future<Iterable<PromotionBanner>> getAllBanner();
}