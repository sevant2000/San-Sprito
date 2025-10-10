import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:san_sprito/bloc/promotion_bloc/promotion_event.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_state.dart';
import 'package:san_sprito/models/create_promotion_response.dart';
import 'package:san_sprito/models/delete_promotion_response.dart';
import 'package:san_sprito/models/promotion_list_response.dart';
import 'package:san_sprito/services/api_services.dart';

class CreatePromotionBloc
    extends Bloc<CreatePromotionEventClass, CreatePromotionState> {
  final ApiService apiService;

  CreatePromotionBloc({required this.apiService})
    : super(CreatePromotionInitial("Welcome")) {
    on<CreatePromotionEvent>((event, emit) async {
      emit(CreatePromotionLoading());

      try {
        final response = await apiService.createPromotion(
          salesmanId: event.salesmanId,
          shopId: event.shopId,
          brandName: event.brandName,
          noOfBottles: event.noOfBottles,
          categoryName: event.categoryName,
        );
        debugPrint("Status code: ${response.statusCode}");
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final createPromotionResponse = CreatePromotionResponse.fromJson(
            jsonMap,
          );

          emit(
            CreatePromotionSuccess(
              createPromotionResponse: createPromotionResponse,
            ),
          );
        } else {
          emit(CreatePromotionFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(CreatePromotionFailure(error: e.toString()));
      }
    });

    on<PromotionListEvent>((event, emit) async {
      emit(CreatePromotionLoading());

      try {
        final http.Response response = await apiService.getPromotionList();

        debugPrint("✅ Status code: ${response.statusCode}");
        debugPrint("📨 Raw Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ JSON Decoded Successfully");

          final promotionListResponse = PromotionListResponse.fromJson(data);

          debugPrint("✅ Parsed Model: ${promotionListResponse.toJson()}");
          emit(
            PromotionListSuccess(promotionListResponse: promotionListResponse),
          );
        } else {
          debugPrint("❌ Invalid status code");
          emit(CreatePromotionFailure(error: 'Invalid credentials'));
        }
      } catch (e, stacktrace) {
        debugPrint("❌ Exception occurred: $e");
        debugPrint("📌 Stacktrace: $stacktrace");
        emit(CreatePromotionFailure(error: e.toString()));
      }
    });

    on<UpdatePromotionEvent>((event, emit) async {
      emit(CreatePromotionLoading());

      try {
        final response = await apiService.updatePromotion(
          promotionId: event.promotionId,
          noOfBottles: event.noOfBottles,
          brandName: event.brandName,
        );
        debugPrint("Status code: ${response.statusCode}");
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final createPromotionResponse = CreatePromotionResponse.fromJson(
            jsonMap,
          );

          emit(
            UpdatePromotionSuccess(
              createPromotionResponse: createPromotionResponse,
            ),
          );
        } else {
          emit(CreatePromotionFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(CreatePromotionFailure(error: e.toString()));
      }
    });

    on<DeletePromotionEvent>((event, emit) async {
      emit(CreatePromotionLoading());

      try {
        final response = await apiService.deletePromotion(
          promotionId: event.promotionId,
        );
        debugPrint("Status code: ${response.statusCode}");
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final deletePromotionResponse = DeletePromotionResponse.fromJson(
            jsonMap,
          );

          emit(
            DeletePromotionSuccess(
              deletePromotionResponse: deletePromotionResponse,
            ),
          );
        } else {
          emit(CreatePromotionFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(CreatePromotionFailure(error: e.toString()));
      }
    });
  }
}
