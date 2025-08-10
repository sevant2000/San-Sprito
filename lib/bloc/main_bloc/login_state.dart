import 'package:san_sprito/models/login_response_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {
  final String message;

  LoginInitial(this.message);
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel loginResponseModel;
  LoginSuccess({required this.loginResponseModel});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}


