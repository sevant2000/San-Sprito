abstract class BarListEventClass {}

class BarListEvent extends BarListEventClass {
  final String userId;

  BarListEvent({required this.userId});
}

class SaveBarRemarkEvent extends BarListEventClass {
  final String shopId;
  final String message;

  SaveBarRemarkEvent({required this.shopId, required this.message});
}

class UpdateBarStatusEvent extends BarListEventClass {
  final String shopId;

  UpdateBarStatusEvent({required this.shopId});
}
