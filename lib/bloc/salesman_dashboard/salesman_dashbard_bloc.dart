import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_event.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_state.dart';
import 'package:san_sprito/models/create_shop_stock_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';
import 'package:san_sprito/models/upload_image_response.dart';
import 'package:san_sprito/services/api_services.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class SalesmanDashBoardBloc
    extends Bloc<SalesmanDashBoardEventClass, SalesmanDashBoardState> {
  final ApiService apiService;

  SalesmanDashBoardBloc({required this.apiService})
    : super(SalesmanDashBoardInitial("Welcome")) {
    on<SalesmanDashBoardEvent>((event, emit) async {
      emit(SalesmanDashBoardLoading());

      try {
        final response = await apiService.createShopStock(
          loginId: event.loginId,
          shopId: event.shopId,
          loginLocation: event.loginLocation,
          deviceName: event.deviceName,
        );
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final createShopStockResponseModel =
              CreateShopStockResponseModel.fromJson(jsonMap);

          emit(
            SalesmanDashBoardSuccess(
              createShopStockResponseModel: createShopStockResponseModel,
            ),
          );
        } else {
          emit(SalesmanDashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesmanDashBoardFailure(error: e.toString()));
      }
    });

    on<GetBrandProductListEvent>((event, emit) async {
      emit(SalesmanDashBoardLoading());

      try {
        final response = await apiService.getProductBrand(event.brandName);
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final getBrandProductResponseModel =
              GetBrandProductResponseModel.fromJson(jsonMap);

          emit(
            GetBrandProductListSuccess(
              getBrandProductResponseModel: getBrandProductResponseModel,
            ),
          );
        } else {
          emit(SalesmanDashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesmanDashBoardFailure(error: e.toString()));
      }
    });

    on<SaveStockEvent>((event, emit) async {
      emit(SaveStockLoadingState());

      try {
        final response = await apiService.saveShopStock(
          shopId: event.shopId,
          stockList: event.stockList,
        );
        debugPrint("Status code: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          final saveStockResponse = SaveStockResponse.fromJson(jsonMap);

          emit(SaveStockSuccess(saveStockResponse: saveStockResponse));
        } else {
          emit(SalesmanDashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesmanDashBoardFailure(error: e.toString()));
      }
    });

    on<UpdateStockEvent>((event, emit) async {
      emit(SaveStockLoadingState());

      try {
        final response = await apiService.updateStock(
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

          emit(UpdateStockSuccess(updateStockResponse: updateStockResp));
        } else {
          emit(SalesmanDashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesmanDashBoardFailure(error: e.toString()));
      }
    });

    on<DeleteStockEvent>((event, emit) async {
      emit(SaveStockLoadingState());

      try {
        final response = await apiService.deleteStock(event.stockId);
        debugPrint("Status code: ${response.statusCode}");
       

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);
          final updateStockResp = UpdateStockResponse.fromJson(jsonMap);
          emit(DeleteStockSuccess(updateStockResponse: updateStockResp));
        } else {
          emit(SalesmanDashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesmanDashBoardFailure(error: e.toString()));
      }
    });

    on<UploadImageEvent>((event, emit) async {
      emit(UploadImageLoading());

      try {
        final response = await apiService.uploadShopPhotos(
          event.shopId,
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
            UploadImageListSuccess(
              uploadPhotoResponseModel: uploadImageResponse,
            ),
          );
        } else {
          emit(SalesmanDashBoardFailure(error: 'Invalid credentials'));
        }
      } catch (e, st) {
        debugPrint('❌ BLoC Error: $e');
        debugPrint('Stack trace: $st');
        emit(SalesmanDashBoardFailure(error: e.toString()));
      }
    });
  }
}
