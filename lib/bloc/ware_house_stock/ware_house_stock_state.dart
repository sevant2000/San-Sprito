import 'package:san_sprito/models/ware_house_stock_model.dart';

abstract class WareHouseState {}

class WareHouseStockInitial extends WareHouseState {
  final String message;

  WareHouseStockInitial(this.message);
}

class WareHouseStockLoading extends WareHouseState {}

class WareHouseStockSuccess extends WareHouseState {
  final WareHouseStockResponseModel wareHouseStockResponseModel;
  WareHouseStockSuccess({required this.wareHouseStockResponseModel});
}

class WareHouseStockFailure extends WareHouseState {
  final String error;

  WareHouseStockFailure({required this.error});
}
