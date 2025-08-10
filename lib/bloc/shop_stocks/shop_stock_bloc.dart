import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/shop_stocks/shop_stock_event.dart';
import 'package:san_sprito/bloc/shop_stocks/shop_stock_state.dart';
import 'package:san_sprito/models/shop_stock_data_response_model.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class ShopStockBloc extends Bloc<ShopStockEventClass, ShopStockState> {
  final ApiService apiService;

  ShopStockBloc({required this.apiService})
    : super(ShopStockInitial("Welcome")) {
    on<ShopStockEvent>((event, emit) async {
      emit(ShopStockLoading());

      try {
        final http.Response response = await apiService.shopListData(
          event.userId,
        );

        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final shopStockResponse = ShopStockResponseModel.fromJson(data);
          emit(ShopStockSuccess(shopStockResponseModel: shopStockResponse));
        } else {
          emit(ShopStockFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(ShopStockFailure(error: e.toString()));
      }
    });
  }
}
