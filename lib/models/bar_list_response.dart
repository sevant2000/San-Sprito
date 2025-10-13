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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? licence;
  String? district;
  String? contactPerson;
  String? contactNumber;
  String? status;
  String? salesmanId;
  String? message;

  BarListData({
    this.id,
    this.name,
    this.licence,
    this.district,
    this.contactPerson,
    this.contactNumber,
    this.status,
    this.salesmanId,
    this.message,
  });

  BarListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licence = json['licence'];
    district = json['district'];
    contactPerson = json['contact_person'];
    contactNumber = json['contact_number'];
    status = json['status'];
    salesmanId = json['salesman_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['licence'] = licence;
    data['district'] = district;
    data['contact_person'] = contactPerson;
    data['contact_number'] = contactNumber;
    data['status'] = status;
    data['salesman_id'] = salesmanId;
    data['message'] = message;
    return data;
  }
}
