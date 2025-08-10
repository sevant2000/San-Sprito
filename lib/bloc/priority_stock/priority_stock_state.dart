import 'package:san_sprito/models/priority_stock_response.dart';

abstract class PriorityStockState {}

class PriorityStockInitial extends PriorityStockState {
  final String message;

  PriorityStockInitial(this.message);
}

class PriorityStockLoading extends PriorityStockState {}

class PriorityStockSuccess extends PriorityStockState {
  final PriorityStockResponseModel priorityStockResponseModel;
  PriorityStockSuccess({required this.priorityStockResponseModel});
}

class PriorityStockFailure extends PriorityStockState {
  final String error;

  PriorityStockFailure({required this.error});
}
