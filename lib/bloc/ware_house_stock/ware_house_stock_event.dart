abstract class WareHouseEventClass {}

class WareHouseStockEvent extends WareHouseEventClass {
  final String userId;

  WareHouseStockEvent({required this.userId});
}
