import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/sales_target/sales_target_event.dart';
import 'package:san_sprito/bloc/sales_target/sales_target_state.dart';
import 'package:san_sprito/models/sales_target_response_model.dart';
import 'package:san_sprito/services/api_services.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class SalesTargetBloc extends Bloc<SalesTargetEventClass, SalesTargetState> {
  final ApiService apiService;

  SalesTargetBloc({required this.apiService})
    : super(SalesTargetInitial("Welcome")) {
    on<SalesTargetEvent>((event, emit) async {
      emit(SalesTargetLoading());

      try {
        final response = await apiService.sellerTargetData(event.userId);
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final salesTargetResponse = SalesTargetResponseModel.fromJson(
            jsonMap,
          );

          emit(
            SalesTargetSuccess(salesTargetResponseModel: salesTargetResponse),
          );
        } else {
          emit(SalesTargetFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesTargetFailure(error: e.toString()));
      }
    });
  }
}
