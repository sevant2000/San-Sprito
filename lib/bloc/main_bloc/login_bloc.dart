import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/services/api_services.dart';
import '../../models/login_response_model.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc({required this.apiService}) : super(LoginInitial("Welcome")) {
    on<LoginUserEvent>((event, emit) async {
      emit(LoginLoading());

      try {
        final http.Response response = await apiService.login(
          event.username,
          event.password,
          event.loginLocation,
          event.deviceName,
        );

        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final loginResponse = LoginResponseModel.fromJson(data);
          debugPrint("loginResponse---${loginResponse.data?.firstname}");
          emit(LoginSuccess(loginResponseModel: loginResponse));
        } else {
          emit(LoginFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });


  }
}
