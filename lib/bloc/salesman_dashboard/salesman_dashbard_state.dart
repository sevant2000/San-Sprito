import 'package:san_sprito/models/create_shop_stock_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';
import 'package:san_sprito/models/upload_image_response.dart';

abstract class SalesmanDashBoardState {}

class SalesmanDashBoardInitial extends SalesmanDashBoardState {
  final String message;

  SalesmanDashBoardInitial(this.message);
}

class SalesmanDashBoardLoading extends SalesmanDashBoardState {}

class SalesmanDashBoardSuccess extends SalesmanDashBoardState {
  final CreateShopStockResponseModel createShopStockResponseModel;
  SalesmanDashBoardSuccess({required this.createShopStockResponseModel});
}

class SaveStockLoadingState extends SalesmanDashBoardState {}

class SaveStockSuccess extends SalesmanDashBoardState {
  final SaveStockResponse saveStockResponse;
  SaveStockSuccess({required this.saveStockResponse});
}

class UpdateStockSuccess extends SalesmanDashBoardState {
  final UpdateStockResponse updateStockResponse;
  UpdateStockSuccess({required this.updateStockResponse});
}

class DeleteStockSuccess extends SalesmanDashBoardState {
  final UpdateStockResponse updateStockResponse;
  DeleteStockSuccess({required this.updateStockResponse});
}

class SalesmanDashBoardFailure extends SalesmanDashBoardState {
  final String error;

  SalesmanDashBoardFailure({required this.error});
}

class GetBrandProductListSuccess extends SalesmanDashBoardState {
  final GetBrandProductResponseModel getBrandProductResponseModel;
  GetBrandProductListSuccess({required this.getBrandProductResponseModel});
}


class UploadImageListSuccess extends SalesmanDashBoardState {
  final UploadPhotoResponseModel uploadPhotoResponseModel;
  UploadImageListSuccess({required this.uploadPhotoResponseModel});
}

class UploadImageLoading extends SalesmanDashBoardState {}
