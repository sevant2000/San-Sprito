import 'package:san_sprito/models/assigned_shop_list_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';

abstract class AssignedShopListState {}

class AssignedShopListInitial extends AssignedShopListState {
  final String message;

  AssignedShopListInitial(this.message);
}

class AssignedShopListLoading extends AssignedShopListState {}

class AssignedShopListSuccess extends AssignedShopListState {
  final AssignedShopListResponseList assignedShopListResponseList;
  AssignedShopListSuccess({required this.assignedShopListResponseList});
}

class AssignedShopListFailure extends AssignedShopListState {
  final String error;

  AssignedShopListFailure({required this.error});
}

class SaveRemarkSuccessState extends AssignedShopListState {
  final UpdateStockResponse commonResponseForMsg;
  SaveRemarkSuccessState({required this.commonResponseForMsg});
}


class UpdateStatusSuccessState extends AssignedShopListState {
  final UpdateStockResponse commonResponseForMsg;
  UpdateStatusSuccessState({required this.commonResponseForMsg});
}
