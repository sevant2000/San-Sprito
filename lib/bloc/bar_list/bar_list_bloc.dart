import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/bar_list/bar_list_event.dart';
import 'package:san_sprito/bloc/bar_list/bar_list_state.dart';
import 'package:san_sprito/models/bar_list_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class BarListBloc extends Bloc<BarListEventClass, BarListStateClass> {
  final ApiService apiService;

  BarListBloc({required this.apiService}) : super(BarListInitial("Welcome")) {
    on<BarListEvent>((event, emit) async {
      emit(BarListLoading());
      debugPrint(
        "📦 Event received: WareHouseStockEvent for userId: ${event.userId}",
      );

      try {
        final http.Response response = await apiService.assignedBarList(
          event.userId,
        );

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final barListResponse = BarListResponse.fromJson(data);

          debugPrint("✅ Parsed Model: ${barListResponse.toJson()}");
          emit(BarListSuccess(barListResponse: barListResponse));
        } else {
          debugPrint("❌ Invalid status code");
          emit(BarListFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(BarListFailure(error: e.toString()));
      }
    });

    on<SaveBarRemarkEvent>((event, emit) async {
      emit(BarListLoading());

      try {
        final http.Response response = await apiService.saveBarRemark(
          barId: event.barId,
          message: event.message,
        );

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final commonResponseForMsg = UpdateStockResponse.fromJson(data);

          debugPrint("✅ Parsed Model: ${commonResponseForMsg.toJson()}");
          emit(SaveBarRemarkState(commonResponseForMsg: commonResponseForMsg));
        } else {
          debugPrint("❌ Invalid status code");
          emit(BarListFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(BarListFailure(error: e.toString()));
      }
    });

    on<UpdateBarStatusEvent>((event, emit) async {
      emit(BarListLoading());

      try {
        final http.Response response = await apiService.updateShopStatus(
          shopId: event.barId,
        );

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final commonResponseForMsg = UpdateStockResponse.fromJson(data);

          debugPrint("✅ Parsed Model: ${commonResponseForMsg.toJson()}");
          emit(UpdateSuccessState(commonResponseForMsg: commonResponseForMsg));
        } else {
          debugPrint("❌ Invalid status code");
          emit(BarListFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(BarListFailure(error: e.toString()));
      }
    });
  }
}
