class SalesTargetResponseModel {
  int? status;
  String? message;
  List<SalesTargetListData>? data;

  SalesTargetResponseModel({this.status, this.message, this.data});

  SalesTargetResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data =
          (json['data'] as List)
              .map((e) => SalesTargetListData.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesTargetListData {
  String? id;
  String? salesmanId;
  String? salesmanName;
  String? brandId;
  String? brandName;
  String? labelName;
  String? assignedQuantity;
  String? completedQuantity;
  String? createdAt;
  String? updatedAt;

  SalesTargetListData({
    this.id,
    this.salesmanId,
    this.salesmanName,
    this.brandId,
    this.brandName,
    this.labelName,
    this.assignedQuantity,
    this.completedQuantity,
    this.createdAt,
    this.updatedAt,
  });

  SalesTargetListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesmanId = json['salesman_id'];
    salesmanName = json['salesman_name'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    labelName = json['label_name'];
    assignedQuantity = json['assigned_quantity'];
    completedQuantity = json['completed_quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesman_id'] = salesmanId;
    data['salesman_name'] = salesmanName;
    data['brand_id'] = brandId;
    data['brand_name'] = brandName;
    data['label_name'] = labelName;
    data['assigned_quantity'] = assignedQuantity;
    data['completed_quantity'] = completedQuantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
