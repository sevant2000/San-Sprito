class CreateShopStockResponseModel {
  int? status;
  String? message;
  CreateShopStockData? data;

  CreateShopStockResponseModel({this.status, this.message, this.data});

  CreateShopStockResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CreateShopStockData.fromJson(json['data']) : null;
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

class CreateShopStockData {
  List<Shops>? shops;
  List<Categories>? categories;
  List<Stocks>? stocks;

  CreateShopStockData({this.shops, this.categories, this.stocks});

  CreateShopStockData.fromJson(Map<String, dynamic> json) {
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
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(Stocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (stocks != null) {
      data['stocks'] = stocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  String? id;
  String? name;
  String? licence;
  String? contactPerson;
  String? contactNumber;
  String? status;
  String? salesmanId;
  String? message;

  Shops(
      {this.id,
      this.name,
      this.licence,
      this.contactPerson,
      this.contactNumber,
      this.status,
      this.salesmanId,
      this.message});

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licence = json['licence'];
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
    data['contact_person'] = contactPerson;
    data['contact_number'] = contactNumber;
    data['status'] = status;
    data['salesman_id'] = salesmanId;
    data['message'] = message;
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
      this.shopName});

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
    return data;
  }
}