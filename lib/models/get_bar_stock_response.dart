class GetBarStockDataResponse {
  int? status;
  String? message;
  BarStockData? data;

  GetBarStockDataResponse({this.status, this.message, this.data});

  GetBarStockDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BarStockData.fromJson(json['data']) : null;
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

class BarStockData {
  List<Stocks>? stocks;
  List<Bars>? bars;
  List<Categories>? categories;

  BarStockData({this.stocks, this.bars, this.categories});

  BarStockData.fromJson(Map<String, dynamic> json) {
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(Stocks.fromJson(v));
      });
    }
    if (json['bars'] != null) {
      bars = <Bars>[];
      json['bars'].forEach((v) {
        bars!.add(Bars.fromJson(v));
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
    if (bars != null) {
      data['bars'] = bars!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stocks {
  String? id;
  String? barId;
  String? brandName;
  String? labelName;
  String? lastStock;
  String? stockIn;
  String? totalStock;
  String? closingStock;
  String? totalSales;
  String? createdAt;
  String? updatedAt;
  String? barName;
  String? salesmanId;

  Stocks(
      {this.id,
        this.barId,
        this.brandName,
        this.labelName,
        this.lastStock,
        this.stockIn,
        this.totalStock,
        this.closingStock,
        this.totalSales,
        this.createdAt,
        this.updatedAt,
        this.barName,
        this.salesmanId});

  Stocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barId = json['bar_id'];
    brandName = json['brand_name'];
    labelName = json['label_name'];
    lastStock = json['last_stock'];
    stockIn = json['stock_in'];
    totalStock = json['total_stock'];
    closingStock = json['closing_stock'];
    totalSales = json['total_sales'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    barName = json['bar_name'];
    salesmanId = json['salesman_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bar_id'] = barId;
    data['brand_name'] = brandName;
    data['label_name'] = labelName;
    data['last_stock'] = lastStock;
    data['stock_in'] = stockIn;
    data['total_stock'] = totalStock;
    data['closing_stock'] = closingStock;
    data['total_sales'] = totalSales;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bar_name'] = barName;
    data['salesman_id'] = salesmanId;
    return data;
  }
}

class Bars {
  String? id;
  String? name;
  String? district;
  String? category;
  String? classification;
  String? salesmanId;
  String? status;
  String? dateCreated;

  Bars(
      {this.id,
        this.name,
        this.district,
        this.category,
        this.classification,
        this.salesmanId,
        this.status,
        this.dateCreated});

  Bars.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    district = json['district'];
    category = json['category'];
    classification = json['classification'];
    salesmanId = json['salesman_id'];
    status = json['status'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['district'] = district;
    data['category'] = category;
    data['classification'] = classification;
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
