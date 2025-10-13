class BarListResponse {
  int? status;
  String? message;
  List<BarListData>? data;

  BarListResponse({this.status, this.message, this.data});

  BarListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BarListData>[];
      json['data'].forEach((v) {
        data!.add(BarListData.fromJson(v));
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

class BarListData {
  String? id;
  String? name;
  String? district;
  String? category;
  String? classification;
  String? status;
  String? salesmanId;
  String? message;

  BarListData(
      {this.id,
        this.name,
        this.district,
        this.category,
        this.classification,
        this.status,
        this.salesmanId,
        this.message});

  BarListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    district = json['district'];
    category = json['category'];
    classification = json['classification'];
    status = json['status'];
    salesmanId = json['salesman_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['district'] = district;
    data['category'] = category;
    data['classification'] = classification;
    data['status'] = status;
    data['salesman_id'] = salesmanId;
    data['message'] = message;
    return data;
  }
}
