import 'package:san_sprito/models/shop_stock_data_response_model.dart';

abstract class ShopStockState {}

class ShopStockInitial extends ShopStockState {
  final String message;

  ShopStockInitial(this.message);
}

class ShopStockLoading extends ShopStockState {}

class ShopStockSuccess extends ShopStockState {
  final ShopStockResponseModel shopStockResponseModel;
  ShopStockSuccess({required this.shopStockResponseModel});
}

class ShopStockFailure extends ShopStockState {
  final String error;

  ShopStockFailure({required this.error});
}
