import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:san_sprito/bloc/ware_house_stock/ware_house_stock_event.dart';
import 'package:san_sprito/bloc/ware_house_stock/ware_house_stock_state.dart';
import 'package:san_sprito/models/ware_house_stock_model.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class WareHouseStockBloc extends Bloc<WareHouseEventClass, WareHouseState> {
  final ApiService apiService;

  WareHouseStockBloc({required this.apiService})
      : super(WareHouseStockInitial("Welcome")) {
    on<WareHouseStockEvent>((event, emit) async {
      emit(WareHouseStockLoading());
      debugPrint("📦 Event received: WareHouseStockEvent for userId: ${event.userId}");

      try {
        final http.Response response =
            await apiService.wareHouserStockData(event.userId);

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final wareHouseStockResponse =
              WareHouseStockResponseModel.fromJson(data);

          debugPrint("✅ Parsed Model: ${wareHouseStockResponse.toJson()}");
          emit(WareHouseStockSuccess(
              wareHouseStockResponseModel: wareHouseStockResponse));
        } else {
          debugPrint("❌ Invalid status code");
          emit(WareHouseStockFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(WareHouseStockFailure(error: e.toString()));
      }
    });
  }
}
