class SaveStockResponse {
  int? status;
  String? message;
  String? data;

  SaveStockResponse({this.status, this.message, this.data});

  SaveStockResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}

class UpdateStockResponse {
  int? status;
  String? message;
  bool? data;

  UpdateStockResponse({this.status, this.message, this.data});

  UpdateStockResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}