class WareHouseStockResponseModel {
  int? status;
  String? message;
  WareHouseStockData? data;

  WareHouseStockResponseModel({this.status, this.message, this.data});

  WareHouseStockResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? WareHouseStockData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WareHouseStockData {
  String? loginId;
  List<ShopDistrict>? shopDistrict;
  List<MergedInventory>? mergedInventory;
  List<Categories>? categories;
  List<Warehouses>? warehouses;

  WareHouseStockData(
      {this.loginId,
      this.shopDistrict,
      this.mergedInventory,
      this.categories,
      this.warehouses});

  WareHouseStockData.fromJson(Map<String, dynamic> json) {
    loginId = json['login_id'];
    if (json['shop_district'] != null) {
      shopDistrict = <ShopDistrict>[];
      json['shop_district'].forEach((v) {
        shopDistrict!.add(ShopDistrict.fromJson(v));
      });
    }
    if (json['merged_inventory'] != null) {
      mergedInventory = <MergedInventory>[];
      json['merged_inventory'].forEach((v) {
        mergedInventory!.add(MergedInventory.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['warehouses'] != null) {
      warehouses = <Warehouses>[];
      json['warehouses'].forEach((v) {
        warehouses!.add(Warehouses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login_id'] = loginId;
    if (shopDistrict != null) {
      data['shop_district'] =
          shopDistrict!.map((v) => v.toJson()).toList();
    }
    if (mergedInventory != null) {
      data['merged_inventory'] =
          mergedInventory!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (warehouses != null) {
      data['warehouses'] = warehouses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopDistrict {
  String? id;
  String? name;
  String? licence;
  String? district;
  String? contactPerson;
  String? contactNumber;
  String? salesmanId;
  String? status;
  String? dateCreated;

  ShopDistrict(
      {this.id,
      this.name,
      this.licence,
      this.district,
      this.contactPerson,
      this.contactNumber,
      this.salesmanId,
      this.status,
      this.dateCreated});

  ShopDistrict.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licence = json['licence'];
    district = json['district'];
    contactPerson = json['contact_person'];
    contactNumber = json['contact_number'];
    salesmanId = json['salesman_id'];
    status = json['status'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['licence'] = licence;
    data['district'] = district;
    data['contact_person'] = contactPerson;
    data['contact_number'] = contactNumber;
    data['salesman_id'] = salesmanId;
    data['status'] = status;
    data['date_created'] = dateCreated;
    return data;
  }
}

class MergedInventory {
  String? labelName;
  String? brand;
  String? warehouseDistrict;
  String? warehouseName;
  String? bottleSize;
  String? totalQuantityInCases;
  String? totalQuantityInBottles;
  String? totalWastageCases;
  String? totalWastageBottles;
  num? finalQuantityInCases;
  num? finalQuantityInBottles;

  MergedInventory(
      {this.labelName,
      this.brand,
      this.warehouseDistrict,
      this.warehouseName,
      this.bottleSize,
      this.totalQuantityInCases,
      this.totalQuantityInBottles,
      this.totalWastageCases,
      this.totalWastageBottles,
      this.finalQuantityInCases,
      this.finalQuantityInBottles});

  MergedInventory.fromJson(Map<String, dynamic> json) {
    labelName = json['label_name'];
    brand = json['brand'];
    warehouseDistrict = json['warehouse_district'];
    warehouseName = json['warehouse_name'];
    bottleSize = json['bottle_size'];
    totalQuantityInCases = json['total_quantity_in_cases'];
    totalQuantityInBottles = json['total_quantity_in_bottles'];
    totalWastageCases = json['total_wastage_cases'];
    totalWastageBottles = json['total_wastage_bottles'];
    finalQuantityInCases = json['final_quantity_in_cases'];
    finalQuantityInBottles = json['final_quantity_in_bottles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label_name'] = labelName;
    data['brand'] = brand;
    data['warehouse_district'] = warehouseDistrict;
    data['warehouse_name'] = warehouseName;
    data['bottle_size'] = bottleSize;
    data['total_quantity_in_cases'] = totalQuantityInCases;
    data['total_quantity_in_bottles'] = totalQuantityInBottles;
    data['total_wastage_cases'] = totalWastageCases;
    data['total_wastage_bottles'] = totalWastageBottles;
    data['final_quantity_in_cases'] = finalQuantityInCases;
    data['final_quantity_in_bottles'] = finalQuantityInBottles;
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Categories({this.id, this.name, this.createdAt, this.updatedAt});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Warehouses {
  String? id;
  String? warehouseName;
  String? warehouseDistrict;
  String? createdAt;
  String? updatedAt;

  Warehouses(
      {this.id,
      this.warehouseName,
      this.warehouseDistrict,
      this.createdAt,
      this.updatedAt});

  Warehouses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseName = json['warehouse_name'];
    warehouseDistrict = json['warehouse_district'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warehouse_name'] = warehouseName;
    data['warehouse_district'] = warehouseDistrict;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}