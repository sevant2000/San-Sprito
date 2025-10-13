import 'package:san_sprito/models/create_promotion_response.dart';
import 'package:san_sprito/models/delete_promotion_response.dart';
import 'package:san_sprito/models/promotion_list_response.dart';

abstract class CreatePromotionState {}

class CreatePromotionInitial extends CreatePromotionState {
  final String message;

  CreatePromotionInitial(this.message);
}

class CreatePromotionLoading extends CreatePromotionState {}

class CreatePromotionFailure extends CreatePromotionState {
  final String error;

  CreatePromotionFailure({required this.error});
}

class CreatePromotionSuccess extends CreatePromotionState {
  final CreatePromotionResponse createPromotionResponse;
  CreatePromotionSuccess({required this.createPromotionResponse});
}

class UpdatePromotionSuccess extends CreatePromotionState {
  final CreatePromotionResponse createPromotionResponse;
  UpdatePromotionSuccess({required this.createPromotionResponse});
}

class PromotionListSuccess extends CreatePromotionState {
  final PromotionListResponse promotionListResponse;
  PromotionListSuccess({required this.promotionListResponse});
}

class DeletePromotionSuccess extends CreatePromotionState {
  final DeletePromotionResponse deletePromotionResponse;
  DeletePromotionSuccess({required this.deletePromotionResponse});
}
