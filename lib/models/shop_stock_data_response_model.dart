class ShopStockResponseModel {
  int? status;
  String? message;
  ShopStockData? data;

  ShopStockResponseModel({this.status, this.message, this.data});

  ShopStockResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ShopStockData.fromJson(json['data']) : null;
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

class ShopStockData {
  List<Stocks>? stocks;
  List<Shops>? shops;
  List<Categories>? categories;

  ShopStockData({this.stocks, this.shops, this.categories});

  ShopStockData.fromJson(Map<String, dynamic> json) {
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(Stocks.fromJson(v));
      });
    }
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(Shops.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stocks != null) {
      data['stocks'] = stocks!.map((v) => v.toJson()).toList();
    }
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stocks {
  String? id;
  String? shopId;
  String? brandName;
  String? labelName;
  String? lastStock;
  String? stockIn;
  String? totalStock;
  String? closingStock;
  String? totalSales;
  String? createdAt;
  String? updatedAt;
  String? shopName;
  String? salesmanId;

  Stocks(
      {this.id,
      this.shopId,
      this.brandName,
      this.labelName,
      this.lastStock,
      this.stockIn,
      this.totalStock,
      this.closingStock,
      this.totalSales,
      this.createdAt,
      this.updatedAt,
      this.shopName,
      this.salesmanId});

  Stocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    brandName = json['brand_name'];
    labelName = json['label_name'];
    lastStock = json['last_stock'];
    stockIn = json['stock_in'];
    totalStock = json['total_stock'];
    closingStock = json['closing_stock'];
    totalSales = json['total_sales'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shopName = json['shop_name'];
    salesmanId = json['salesman_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['brand_name'] = brandName;
    data['label_name'] = labelName;
    data['last_stock'] = lastStock;
    data['stock_in'] = stockIn;
    data['total_stock'] = totalStock;
    data['closing_stock'] = closingStock;
    data['total_sales'] = totalSales;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['shop_name'] = shopName;
    data['salesman_id'] = salesmanId;
    return data;
  }
}

class Shops {
  String? id;
  String? name;
  String? licence;
  String? district;
  String? contactPerson;
  String? contactNumber;
  String? salesmanId;
  String? status;
  String? dateCreated;

  Shops(
      {this.id,
      this.name,
      this.licence,
      this.district,
      this.contactPerson,
      this.contactNumber,
      this.salesmanId,
      this.status,
      this.dateCreated});

  Shops.fromJson(Map<String, dynamic> json) {
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