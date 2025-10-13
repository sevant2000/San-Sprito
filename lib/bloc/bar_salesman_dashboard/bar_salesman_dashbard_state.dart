import 'package:san_sprito/models/bar_salesman_dashboard_list_data_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';
import 'package:san_sprito/models/upload_image_response.dart';

abstract class BarSalesmanDashboardState {}

class BarSalesmanDashboardInitial extends BarSalesmanDashboardState {
  final String message;

  BarSalesmanDashboardInitial(this.message);
}

class BarSalesmanDashboardLoading extends BarSalesmanDashboardState {}

class SaveBarStockLoadingState extends BarSalesmanDashboardState {}

class BarSalesmanDashBoardSuccess extends BarSalesmanDashboardState {
  final BarSalesmanDashBoardDataResponse barSalesmanDashBoardDataResponse;
  BarSalesmanDashBoardSuccess({required this.barSalesmanDashBoardDataResponse});
}

class BarSaveStockSuccess extends BarSalesmanDashboardState {
  final SaveStockResponse saveStockResponse;
  BarSaveStockSuccess({required this.saveStockResponse});
}

class UpdateBarStockSuccess extends BarSalesmanDashboardState {
  final UpdateStockResponse updateStockResponse;
  UpdateBarStockSuccess({required this.updateStockResponse});
}

class DeleteBarStockSuccess extends BarSalesmanDashboardState {
  final UpdateStockResponse updateStockResponse;
  DeleteBarStockSuccess({required this.updateStockResponse});
}

class BarSalesmanFailure extends BarSalesmanDashboardState {
  final String error;

  BarSalesmanFailure({required this.error});
}

class GetBarBrandProductListSuccess extends BarSalesmanDashboardState {
  final GetBrandProductResponseModel getBrandProductResponseModel;
  GetBarBrandProductListSuccess({required this.getBrandProductResponseModel});
}


class UploadBarImageSuccess extends BarSalesmanDashboardState {
  final UploadPhotoResponseModel uploadPhotoResponseModel;
  UploadBarImageSuccess({required this.uploadPhotoResponseModel});
}

class UploadBarImageLoading extends BarSalesmanDashboardState {}
