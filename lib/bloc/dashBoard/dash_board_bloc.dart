import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/dashBoard/dash_board_event.dart';
import 'package:san_sprito/bloc/dashBoard/dash_board_state.dart';
import 'package:san_sprito/models/common_msg_response_model.dart';
import 'package:san_sprito/models/dashboard_data_response_model.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  final ApiService apiService;

  DashBoardBloc({required this.apiService})
    : super(DashBoardInitial("Welcome")) {
    on<DashBoardDataEvent>((event, emit) async {
      emit(DashBoardLoading());

      try {
        final http.Response response = await apiService.dashBoardData(
          event.userId,
        );

        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final dashBoardResponse = DashBoardResponse.fromJson(data);
          emit(DashBoardSuccess(dashBoardResponse: dashBoardResponse));
        } else {
          emit(DashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(DashBoardFailure(error: e.toString()));
      }
    });


    
    on<LogOutEvent>((event, emit) async {
      emit(DashBoardLoading());

      try {
        final http.Response response = await apiService.logout(
          event.loginId,
          event.loginLocation,
        
        );

        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final logOutResponse = CommonResponseForMsg.fromJson(data);
          emit(LogOutSuccess(commonResponseForMsg: logOutResponse));
        } else {
          emit(DashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(DashBoardFailure(error: e.toString()));
      }
    });
  }
}
