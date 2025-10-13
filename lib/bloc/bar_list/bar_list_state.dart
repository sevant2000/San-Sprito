import 'package:san_sprito/models/bar_list_response.dart';
import 'package:san_sprito/models/save_stock_response.dart';

abstract class BarListStateClass {}

class BarListInitial extends BarListStateClass {
  final String message;

  BarListInitial(this.message);
}

class BarListLoading extends BarListStateClass {}

class BarListSuccess extends BarListStateClass {
  final BarListResponse barListResponse;
  BarListSuccess({required this.barListResponse});
}

class BarListFailure extends BarListStateClass {
  final String error;

  BarListFailure({required this.error});
}

class SaveBarRemarkState extends BarListStateClass {
  final UpdateStockResponse commonResponseForMsg;
  SaveBarRemarkState({required this.commonResponseForMsg});
}


class UpdateSuccessState extends BarListStateClass {
  final UpdateStockResponse commonResponseForMsg;
  UpdateSuccessState({required this.commonResponseForMsg});
}
