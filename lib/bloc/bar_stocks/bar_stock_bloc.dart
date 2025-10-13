import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/bar_stocks/bar_stock_event.dart';
import 'package:san_sprito/bloc/bar_stocks/bar_stock_state.dart';
import 'package:san_sprito/models/get_bar_stock_response.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class BarStockBloc extends Bloc<BarStockEventClass, BarStockState> {
  final ApiService apiService;

  BarStockBloc({required this.apiService})
    : super(BarStockInitial("Welcome")) {
    on<BarStockEvent>((event, emit) async {
      emit(BarStockLoading());

      try {
        final http.Response response = await apiService.barStockListData(
          event.userId,
        );

        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final barStockDataResponse = GetBarStockDataResponse.fromJson(data);
          emit(BarStockSuccess(barStockDataResponse: barStockDataResponse));
        } else {
          emit(BarStockFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(BarStockFailure(error: e.toString()));
      }
    });
  }
}
