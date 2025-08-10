abstract class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String username;
  final String password;
  final String loginLocation;
  final String deviceName;

  LoginUserEvent({required this.username, required this.password, required this.loginLocation, required this.deviceName});
}




