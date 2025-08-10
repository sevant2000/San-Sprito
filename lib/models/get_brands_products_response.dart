class GetBrandProductResponseModel {
  int? status;
  String? message;
  List<GetBrandProductListData>? data;

  GetBrandProductResponseModel({this.status, this.message, this.data});

  GetBrandProductResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetBrandProductListData>[];
      json['data'].forEach((v) {
        data!.add(GetBrandProductListData.fromJson(v));
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

class GetBrandProductListData {
  String? id;
  String? uploadId;
  String? name;
  String? brand;
  String? bottleSize;
  String? noOfBottles;
  String? categoryId;
  String? edpPrice;
  String? mrpPrice;
  String? status;
  String? bottleTypeIds;
  String? bottleSizeIds;
  String? createdAt;
  String? updatedAt;

  GetBrandProductListData(
      {this.id,
      this.uploadId,
      this.name,
      this.brand,
      this.bottleSize,
      this.noOfBottles,
      this.categoryId,
      this.edpPrice,
      this.mrpPrice,
      this.status,
      this.bottleTypeIds,
      this.bottleSizeIds,
      this.createdAt,
      this.updatedAt});

  GetBrandProductListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uploadId = json['upload_id'];
    name = json['name'];
    brand = json['brand'];
    bottleSize = json['bottle_size'];
    noOfBottles = json['no_of_bottles'];
    categoryId = json['category_id'];
    edpPrice = json['edp_price'];
    mrpPrice = json['mrp_price'];
    status = json['status'];
    bottleTypeIds = json['bottle_type_ids'];
    bottleSizeIds = json['bottle_size_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['upload_id'] = uploadId;
    data['name'] = name;
    data['brand'] = brand;
    data['bottle_size'] = bottleSize;
    data['no_of_bottles'] = noOfBottles;
    data['category_id'] = categoryId;
    data['edp_price'] = edpPrice;
    data['mrp_price'] = mrpPrice;
    data['status'] = status;
    data['bottle_type_ids'] = bottleTypeIds;
    data['bottle_size_ids'] = bottleSizeIds;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}