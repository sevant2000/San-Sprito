abstract class DashBoardEvent {}

class DashBoardDataEvent extends DashBoardEvent {
  final String userId;

  DashBoardDataEvent({required this.userId});
}

class LogOutEvent extends DashBoardEvent {
  final String loginId;
  final String loginLocation;

  LogOutEvent({required this.loginId, required this.loginLocation});
}
