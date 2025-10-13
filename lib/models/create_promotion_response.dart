class CreatePromotionResponse {
  int? status;
  String? message;
  dynamic data; // ✅ can hold both int or bool

  CreatePromotionResponse({this.status, this.message, this.data});

  CreatePromotionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] is bool
        ? (json['status'] ? 1 : 0)
        : json['status'];
    message = json['message'];
    data = json['data']; // can be int, bool, or even null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
