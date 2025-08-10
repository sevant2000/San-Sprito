import 'package:san_sprito/models/sales_target_response_model.dart';

abstract class SalesTargetState {}

class SalesTargetInitial extends SalesTargetState {
  final String message;

  SalesTargetInitial(this.message);
}

class SalesTargetLoading extends SalesTargetState {}

class SalesTargetSuccess extends SalesTargetState {
  final SalesTargetResponseModel salesTargetResponseModel;
  SalesTargetSuccess({required this.salesTargetResponseModel});
}

class SalesTargetFailure extends SalesTargetState {
  final String error;

  SalesTargetFailure({required this.error});
}
