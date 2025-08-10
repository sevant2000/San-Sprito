abstract class SalesTargetEventClass {}

class SalesTargetEvent extends SalesTargetEventClass {
  final String userId;

  SalesTargetEvent({required this.userId});
}

