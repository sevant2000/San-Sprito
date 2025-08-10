import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_event.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_state.dart';
import 'package:san_sprito/models/assigned_shop_list_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class AssignedShopListBloc
    extends Bloc<AssignedShopListEventClass, AssignedShopListState> {
  final ApiService apiService;

  AssignedShopListBloc({required this.apiService})
    : super(AssignedShopListInitial("Welcome")) {
    on<AssignedShopListEvent>((event, emit) async {
      emit(AssignedShopListLoading());
      debugPrint(
        "📦 Event received: WareHouseStockEvent for userId: ${event.userId}"
      );

      try {
        final http.Response response = await apiService.assignedShopList(
          event.userId,
        );

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final assignedShopListResponse =
              AssignedShopListResponseList.fromJson(data);

          debugPrint("✅ Parsed Model: ${assignedShopListResponse.toJson()}");
          emit(
            AssignedShopListSuccess(
              assignedShopListResponseList: assignedShopListResponse,
            ),
          );
        } else {
          debugPrint("❌ Invalid status code");
          emit(AssignedShopListFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(AssignedShopListFailure(error: e.toString()));
      }
    });

    on<SaveRemarkEvent>((event, emit) async {
      emit(AssignedShopListLoading());

      try {
        final http.Response response = await apiService.saveRemark(
          shopId: event.shopId,
          message: event.message,
        );

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final commonResponseForMsg = UpdateStockResponse.fromJson(data);

          debugPrint("✅ Parsed Model: ${commonResponseForMsg.toJson()}");
          emit(
            SaveRemarkSuccessState(commonResponseForMsg: commonResponseForMsg),
          );
        } else {
          debugPrint("❌ Invalid status code");
          emit(AssignedShopListFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(AssignedShopListFailure(error: e.toString()));
      }
    });

    on<UpdateStatusEvent>((event, emit) async {
      emit(AssignedShopListLoading());

      try {
        final http.Response response = await apiService.updateShopStatus(
          shopId: event.shopId,
        );

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final commonResponseForMsg = UpdateStockResponse.fromJson(data);

          debugPrint("✅ Parsed Model: ${commonResponseForMsg.toJson()}");
          emit(
            UpdateStatusSuccessState(
              commonResponseForMsg: commonResponseForMsg,
            ),
          );
        } else {
          debugPrint("❌ Invalid status code");
          emit(AssignedShopListFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(AssignedShopListFailure(error: e.toString()));
      }
    });
  }
}
