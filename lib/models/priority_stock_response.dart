class PriorityStockResponseModel {
  int? status;
  String? message;
  PriorityStockData? data;

  PriorityStockResponseModel({this.status, this.message, this.data});

  PriorityStockResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PriorityStockData.fromJson(json['data']) : null;
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

class PriorityStockData {
  String? loginId;
  List<ShopDistrict>? shopDistrict;
  List<Inventory>? inventory;
  List<InventoryStock>? inventoryStock;
  List<Categories>? categories;
  List<Warehouses>? warehouses;

  PriorityStockData(
      {this.loginId,
      this.shopDistrict,
      this.inventory,
      this.inventoryStock,
      this.categories,
      this.warehouses});

  PriorityStockData.fromJson(Map<String, dynamic> json) {
    loginId = json['login_id'];
    if (json['shop_district'] != null) {
      shopDistrict = <ShopDistrict>[];
      json['shop_district'].forEach((v) {
        shopDistrict!.add(ShopDistrict.fromJson(v));
      });
    }
    if (json['inventory'] != null) {
      inventory = <Inventory>[];
      json['inventory'].forEach((v) {
        inventory!.add(Inventory.fromJson(v));
      });
    }
    if (json['inventory_stock'] != null) {
      inventoryStock = <InventoryStock>[];
      json['inventory_stock'].forEach((v) {
        inventoryStock!.add(InventoryStock.fromJson(v));
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
    if (inventory != null) {
      data['inventory'] = inventory!.map((v) => v.toJson()).toList();
    }
    if (inventoryStock != null) {
      data['inventory_stock'] =
          inventoryStock!.map((v) => v.toJson()).toList();
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

class Inventory {
  String? id;
  String? tpNo;
  String? tpDate;
  String? evcDate;
  String? expiryDate;
  String? vehicle;
  String? warehouseDistrict;
  String? warehouseName;
  String? labelName;
  String? quantityInCases;
  String? quantityCaseOnTp;
  String? noOfCaseAtVerification;
  String? bottlesAtVerification;
  String? wastageInBottles;
  String? wastageInCases;
  String? mfgCost;
  String? brand;
  String? batchNo;
  String? bottleSize;
  String? priority;
  String? createdAt;

  Inventory(
      {this.id,
      this.tpNo,
      this.tpDate,
      this.evcDate,
      this.expiryDate,
      this.vehicle,
      this.warehouseDistrict,
      this.warehouseName,
      this.labelName,
      this.quantityInCases,
      this.quantityCaseOnTp,
      this.noOfCaseAtVerification,
      this.bottlesAtVerification,
      this.wastageInBottles,
      this.wastageInCases,
      this.mfgCost,
      this.brand,
      this.batchNo,
      this.bottleSize,
      this.priority,
      this.createdAt});

  Inventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tpNo = json['tp_no'];
    tpDate = json['tp_date'];
    evcDate = json['evc_date'];
    expiryDate = json['expiry_date'];
    vehicle = json['vehicle'];
    warehouseDistrict = json['warehouse_district'];
    warehouseName = json['warehouse_name'];
    labelName = json['label_name'];
    quantityInCases = json['quantity_in_cases'];
    quantityCaseOnTp = json['quantity_case_on_tp'];
    noOfCaseAtVerification = json['no_of_case_at_verification'];
    bottlesAtVerification = json['bottles_at_verification'];
    wastageInBottles = json['wastage_in_bottles'];
    wastageInCases = json['wastage_in_cases'];
    mfgCost = json['mfg_cost'];
    brand = json['brand'];
    batchNo = json['batch_no'];
    bottleSize = json['bottle_size'];
    priority = json['priority'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tp_no'] = tpNo;
    data['tp_date'] = tpDate;
    data['evc_date'] = evcDate;
    data['expiry_date'] = expiryDate;
    data['vehicle'] = vehicle;
    data['warehouse_district'] = warehouseDistrict;
    data['warehouse_name'] = warehouseName;
    data['label_name'] = labelName;
    data['quantity_in_cases'] = quantityInCases;
    data['quantity_case_on_tp'] = quantityCaseOnTp;
    data['no_of_case_at_verification'] = noOfCaseAtVerification;
    data['bottles_at_verification'] = bottlesAtVerification;
    data['wastage_in_bottles'] = wastageInBottles;
    data['wastage_in_cases'] = wastageInCases;
    data['mfg_cost'] = mfgCost;
    data['brand'] = brand;
    data['batch_no'] = batchNo;
    data['bottle_size'] = bottleSize;
    data['priority'] = priority;
    data['created_at'] = createdAt;
    return data;
  }
}

class InventoryStock {
  String? id;
  String? tpNo;
  String? tpDate;
  String? evcDate;
  String? expiryDate;
  String? vehicle;
  String? warehouseDistrict;
  String? warehouseName;
  String? labelName;
  String? quantityInCases;
  String? quantityCaseOnTp;
  String? noOfCaseAtVerification;
  String? bottlesAtVerification;
  String? wastageInBottles;
  String? wastageInCases;
  String? mfgCost;
  String? brand;
  String? batchNo;
  String? bottleSize;
  String? priority;
  String? createdAt;
  String? formattedCreatedAt;

  InventoryStock(
      {this.id,
      this.tpNo,
      this.tpDate,
      this.evcDate,
      this.expiryDate,
      this.vehicle,
      this.warehouseDistrict,
      this.warehouseName,
      this.labelName,
      this.quantityInCases,
      this.quantityCaseOnTp,
      this.noOfCaseAtVerification,
      this.bottlesAtVerification,
      this.wastageInBottles,
      this.wastageInCases,
      this.mfgCost,
      this.brand,
      this.batchNo,
      this.bottleSize,
      this.priority,
      this.createdAt,
      this.formattedCreatedAt});

  InventoryStock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tpNo = json['tp_no'];
    tpDate = json['tp_date'];
    evcDate = json['evc_date'];
    expiryDate = json['expiry_date'];
    vehicle = json['vehicle'];
    warehouseDistrict = json['warehouse_district'];
    warehouseName = json['warehouse_name'];
    labelName = json['label_name'];
    quantityInCases = json['quantity_in_cases'];
    quantityCaseOnTp = json['quantity_case_on_tp'];
    noOfCaseAtVerification = json['no_of_case_at_verification'];
    bottlesAtVerification = json['bottles_at_verification'];
    wastageInBottles = json['wastage_in_bottles'];
    wastageInCases = json['wastage_in_cases'];
    mfgCost = json['mfg_cost'];
    brand = json['brand'];
    batchNo = json['batch_no'];
    bottleSize = json['bottle_size'];
    priority = json['priority'];
    createdAt = json['created_at'];
    formattedCreatedAt = json['formatted_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tp_no'] = tpNo;
    data['tp_date'] = tpDate;
    data['evc_date'] = evcDate;
    data['expiry_date'] = expiryDate;
    data['vehicle'] = vehicle;
    data['warehouse_district'] = warehouseDistrict;
    data['warehouse_name'] = warehouseName;
    data['label_name'] = labelName;
    data['quantity_in_cases'] = quantityInCases;
    data['quantity_case_on_tp'] = quantityCaseOnTp;
    data['no_of_case_at_verification'] = noOfCaseAtVerification;
    data['bottles_at_verification'] = bottlesAtVerification;
    data['wastage_in_bottles'] = wastageInBottles;
    data['wastage_in_cases'] = wastageInCases;
    data['mfg_cost'] = mfgCost;
    data['brand'] = brand;
    data['batch_no'] = batchNo;
    data['bottle_size'] = bottleSize;
    data['priority'] = priority;
    data['created_at'] = createdAt;
    data['formatted_created_at'] = formattedCreatedAt;
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