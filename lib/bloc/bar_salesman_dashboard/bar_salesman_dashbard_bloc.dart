import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/bar_salesman_dashboard/bar_salesman_dashbard_event.dart';
import 'package:san_sprito/bloc/bar_salesman_dashboard/bar_salesman_dashbard_state.dart';
import 'package:san_sprito/models/bar_salesman_dashboard_list_data_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';
import 'package:san_sprito/models/upload_image_response.dart';
import 'package:san_sprito/services/api_services.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class BarSalesmanDashboardBloc
    extends Bloc<BarSalesmanDashboardEventClass, BarSalesmanDashboardState> {
  final ApiService apiService;

  BarSalesmanDashboardBloc({required this.apiService})
    : super(BarSalesmanDashboardInitial("Welcome")) {
    on<BarSalesmanDashboardEvent>((event, emit) async {
      emit(BarSalesmanDashboardLoading());

      try {
        final response = await apiService.createBarStock(
          loginId: event.loginId,
          barId: event.barId,
          loginLocation: event.loginLocation,
          deviceName: event.deviceName,
        );
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final barSalesmanDashBoardDataResponse =
              BarSalesmanDashBoardDataResponse.fromJson(jsonMap);

          emit(
            BarSalesmanDashBoardSuccess(
              barSalesmanDashBoardDataResponse:
                  barSalesmanDashBoardDataResponse,
            ),
          );
        } else {
          emit(BarSalesmanFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(BarSalesmanFailure(error: e.toString()));
      }
    });

    on<GetBarBrandProductListEvent>((event, emit) async {
      emit(BarSalesmanDashboardLoading());

      try {
        final response = await apiService.getProductBrand(event.brandName);
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final getBrandProductResponseModel =
              GetBrandProductResponseModel.fromJson(jsonMap);

          emit(
            GetBarBrandProductListSuccess(
              getBrandProductResponseModel: getBrandProductResponseModel,
            ),
          );
        } else {
          emit(BarSalesmanFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(BarSalesmanFailure(error: e.toString()));
      }
    });

    on<SaveBarStockEvent>((event, emit) async {
      emit(SaveBarStockLoadingState());

      try {
        final response = await apiService.saveBarStock(
          barId: event.barId,
          stockList: event.stockList,
        );
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          try {
            final Map<String, dynamic> jsonMap = jsonDecode(response.body);
            final saveStockResponse = SaveStockResponse.fromJson(jsonMap);
            emit(BarSaveStockSuccess(saveStockResponse: saveStockResponse));
          } catch (e) {
            debugPrint("❌ JSON Decode failed: ${response.body}");
            emit(BarSalesmanFailure(error: "Invalid response format"));
          }
        } else {
          debugPrint("❌ API Error: ${response.body}");
          emit(
            BarSalesmanFailure(error: "Server error ${response.statusCode}"),
          );
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(BarSalesmanFailure(error: e.toString()));
      }
    });

    on<UpdateBarStockEvent>((event, emit) async {
      emit(SaveBarStockLoadingState());

      try {
        final response = await apiService.updateBarStock(
          brandName: event.brandName,
          labelName: event.labelName,
          stockIn: event.stockIn,
          lastStock: event.lastStock,
          closingStock: event.closingStock,
          totalStock: event.totalStock,
          stockId: event.stockId,
        );
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final updateStockResp = UpdateStockResponse.fromJson(jsonMap);

          emit(UpdateBarStockSuccess(updateStockResponse: updateStockResp));
        } else {
          emit(BarSalesmanFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(BarSalesmanFailure(error: e.toString()));
      }
    });

    on<DeleteBarStockEvent>((event, emit) async {
      emit(SaveBarStockLoadingState());

      try {
        final response = await apiService.deleteBarStock(event.stockId);
        debugPrint("Status code: ${response.statusCode}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);
          final updateStockResp = UpdateStockResponse.fromJson(jsonMap);
          emit(DeleteBarStockSuccess(updateStockResponse: updateStockResp));
        } else {
          emit(BarSalesmanFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(BarSalesmanFailure(error: e.toString()));
      }
    });

    on<UploadBarImageEvent>((event, emit) async {
      emit(UploadBarImageLoading());

      try {
        final response = await apiService.uploadBarPhotos(
          event.barId,
          event.imageList,
        );
        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Response---- ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final uploadImageResponse = UploadPhotoResponseModel.fromJson(
            jsonMap,
          );

          emit(
            UploadBarImageSuccess(
              uploadPhotoResponseModel: uploadImageResponse,
            ),
          );
        } else {
          emit(BarSalesmanFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(BarSalesmanFailure(error: e.toString()));
      }
    });
  }
}
