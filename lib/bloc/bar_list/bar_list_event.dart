abstract class BarListEventClass {}

class BarListEvent extends BarListEventClass {
  final String userId;

  BarListEvent({required this.userId});
}

class SaveBarRemarkEvent extends BarListEventClass {
  final String barId;
  final String message;

  SaveBarRemarkEvent({required this.barId, required this.message});
}

class UpdateBarStatusEvent extends BarListEventClass {
  final String barId;

  UpdateBarStatusEvent({required this.barId});
}
