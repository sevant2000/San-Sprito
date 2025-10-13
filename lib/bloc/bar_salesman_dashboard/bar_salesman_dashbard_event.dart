import 'dart:io';

abstract class BarSalesmanDashboardEventClass {}

class BarSalesmanDashboardEvent extends BarSalesmanDashboardEventClass {
  final String loginId;
  final String barId;
  final String loginLocation;
  final String deviceName;

  BarSalesmanDashboardEvent({
    required this.loginId,
    required this.barId,
    required this.loginLocation,
    required this.deviceName,
  });
}

class GetBarBrandProductListEvent extends BarSalesmanDashboardEventClass {
  final String brandName;

  GetBarBrandProductListEvent({required this.brandName});
}

class SaveBarStockEvent extends BarSalesmanDashboardEventClass {
  final int barId;
  final List<Map<String, dynamic>> stockList;

  SaveBarStockEvent({required this.barId, required this.stockList});
}


class UpdateBarStockEvent extends BarSalesmanDashboardEventClass {
  final String stockId;
  final String? brandName;
  final String? labelName;
  final String? lastStock;
  final String? stockIn;
  final String? totalStock;
  final String? closingStock;

  UpdateBarStockEvent({
    required this.stockId,
    this.brandName,
    this.labelName,
    this.lastStock,
    this.stockIn,
    this.totalStock,
    this.closingStock,
  });
}


class DeleteBarStockEvent extends BarSalesmanDashboardEventClass {
  final String stockId;

  DeleteBarStockEvent({required this.stockId});
}


class UploadBarImageEvent extends BarSalesmanDashboardEventClass {
  final String barId;
  final List<File> imageList;

  UploadBarImageEvent({required this.barId, required this.imageList});
}
