import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/priority_stock/priority_stock_event.dart';
import 'package:san_sprito/bloc/priority_stock/priority_stock_state.dart';
import 'package:san_sprito/models/priority_stock_response.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class PriorityStockBloc
    extends Bloc<PriorityStockEventClass, PriorityStockState> {
  final ApiService apiService;

  PriorityStockBloc({required this.apiService})
    : super(PriorityStockInitial("Welcome")) {
    on<PriorityStockEvent>((event, emit) async {
      emit(PriorityStockLoading());

      try {
        final http.Response response = await apiService.priorityStockData(
          event.userId,
        );

        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final priorityStockResponse = PriorityStockResponseModel.fromJson(
            data,
          );
          emit(
            PriorityStockSuccess(
              priorityStockResponseModel: priorityStockResponse,
            ),
          );
        } else {
          emit(PriorityStockFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(PriorityStockFailure(error: e.toString()));
      }
    });
  }
}
