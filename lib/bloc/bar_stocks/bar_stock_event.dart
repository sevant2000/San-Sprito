abstract class BarStockEventClass {}

class BarStockEvent extends BarStockEventClass {
  final String userId;

  BarStockEvent({required this.userId});
}

