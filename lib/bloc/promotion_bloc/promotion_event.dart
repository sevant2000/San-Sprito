abstract class CreatePromotionEventClass {}

class CreatePromotionEvent extends CreatePromotionEventClass {
  final String shopId;
  final String salesmanId;
  final String brandName;
  final String noOfBottles;
  final String categoryName;

  CreatePromotionEvent({
    required this.shopId,
    required this.salesmanId,
    required this.brandName,
    required this.noOfBottles,
    required this.categoryName,
  });
}

class PromotionListEvent extends CreatePromotionEventClass {
  PromotionListEvent();
}

class UpdatePromotionEvent extends CreatePromotionEventClass {
  final String brandName;
  final int noOfBottles;
  final int promotionId;

  UpdatePromotionEvent({
    required this.brandName,
    required this.noOfBottles,
    required this.promotionId,
  });
}
