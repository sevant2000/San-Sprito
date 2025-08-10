import 'package:san_sprito/models/common_msg_response_model.dart';
import 'package:san_sprito/models/dashboard_data_response_model.dart';

abstract class DashBoardState {}

class DashBoardInitial extends DashBoardState {
  final String message;

  DashBoardInitial(this.message);
}

class DashBoardLoading extends DashBoardState {}

class DashBoardSuccess extends DashBoardState {
  final DashBoardResponse dashBoardResponse;
  DashBoardSuccess({required this.dashBoardResponse});
}

class DashBoardFailure extends DashBoardState {
  final String error;

  DashBoardFailure({required this.error});
}


class LogOutSuccess extends DashBoardState {
  final CommonResponseForMsg commonResponseForMsg;
  LogOutSuccess({required this.commonResponseForMsg});
}