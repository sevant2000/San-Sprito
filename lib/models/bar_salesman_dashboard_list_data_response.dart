import 'package:san_sprito/models/create_shop_stock_response.dart';

class BarSalesmanDashBoardDataResponse {
  int? status;
  String? message;
  BarSalesmanDashboardData? data;

  BarSalesmanDashBoardDataResponse({this.status, this.message, this.data});

  BarSalesmanDashBoardDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null
            ? BarSalesmanDashboardData.fromJson(json['data'])
            : null;
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

class BarSalesmanDashboardData {
  List<Bars>? bars;
  List<Categories>? categories;
  List<Stocks>? stocks;

  BarSalesmanDashboardData({this.bars, this.categories, this.stocks});

  BarSalesmanDashboardData.fromJson(Map<String, dynamic> json) {
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
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(Stocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bars != null) {
      data['bars'] = bars!.map((v) => v.toJson()).toList();
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

class Bars {
  String? id;
  String? name;
  String? category;
  String? classification;
  String? status;
  String? salesmanId;
  String? message;

  Bars({
    this.id,
    this.name,
    this.category,
    this.classification,
    this.status,
    this.salesmanId,
    this.message,
  });

  Bars.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    classification = json['classification'];
    status = json['status'];
    salesmanId = json['salesman_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['classification'] = classification;
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
