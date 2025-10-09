class PromotionListResponse {
  int? status;
  String? message;
  List<PromotionListData>? data;

  PromotionListResponse({this.status, this.message, this.data});

  PromotionListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PromotionListData>[];
      json['data'].forEach((v) {
        data!.add(PromotionListData.fromJson(v));
      });
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

class PromotionListData {
  String? id;
  String? shopId;
  String? categoryName;
  String? salesmanId;
  String? brandName;
  String? noOfBottles;
  String? createdAt;
  String? updatedAt;
  String? shopName;
  String? salesmanName;

  PromotionListData({
    this.id,
    this.shopId,
    this.categoryName,
    this.salesmanId,
    this.brandName,
    this.noOfBottles,
    this.createdAt,
    this.updatedAt,
    this.shopName,
    this.salesmanName,
  });

  PromotionListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    categoryName = json['categoryName'];
    salesmanId = json['salesman_id'];
    brandName = json['brand_name'];
    noOfBottles = json['no_of_bottles'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shopName = json['shop_name'];
    salesmanName = json['salesman_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['categoryName'] = categoryName;
    data['salesman_id'] = salesmanId;
    data['brand_name'] = brandName;
    data['no_of_bottles'] = noOfBottles;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['shop_name'] = shopName;
    data['salesman_name'] = salesmanName;
    return data;
  }
}
