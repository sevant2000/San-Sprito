abstract class AssignedShopListEventClass {}

class AssignedShopListEvent extends AssignedShopListEventClass {
  final String userId;

  AssignedShopListEvent({required this.userId});
}

class SaveRemarkEvent extends AssignedShopListEventClass {
  final String shopId;
  final String message;

  SaveRemarkEvent({required this.shopId, required this.message});
}

class UpdateStatusEvent extends AssignedShopListEventClass {
  final String shopId;

  UpdateStatusEvent({required this.shopId});
}
