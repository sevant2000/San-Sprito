import 'package:san_sprito/models/get_bar_stock_response.dart';

abstract class BarStockState {}

class BarStockInitial extends BarStockState {
  final String message;

  BarStockInitial(this.message);
}

class BarStockLoading extends BarStockState {}

class BarStockSuccess extends BarStockState {
  final GetBarStockDataResponse barStockDataResponse;
  BarStockSuccess({required this.barStockDataResponse});
}

class BarStockFailure extends BarStockState {
  final String error;

  BarStockFailure({required this.error});
}
