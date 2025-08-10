abstract class ShopStockEventClass {}

class ShopStockEvent extends ShopStockEventClass {
  final String userId;

  ShopStockEvent({required this.userId});
}

