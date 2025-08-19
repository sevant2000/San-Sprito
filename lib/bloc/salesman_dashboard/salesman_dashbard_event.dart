import 'dart:io';

abstract class SalesmanDashBoardEventClass {}

class SalesmanDashBoardEvent extends SalesmanDashBoardEventClass {
  final String loginId;
  final String shopId;
  final String loginLocation;
  final String deviceName;

  SalesmanDashBoardEvent({
    required this.loginId,
    required this.shopId,
    required this.loginLocation,
    required this.deviceName,
  });
}

class GetBrandProductListEvent extends SalesmanDashBoardEventClass {
  final String brandName;

  GetBrandProductListEvent({required this.brandName});
}

class SaveStockEvent extends SalesmanDashBoardEventClass {
  final int shopId;
  final List<Map<String, dynamic>> stockList;

  SaveStockEvent({required this.shopId, required this.stockList});
}

// class UpdateStockEvent extends SalesmanDashBoardEventClass {
//   final String stockId;
//   final String brandName;
//   final String labelName;
//   final String lastStock;
//   final String stockIn;
//   final String totalStock;
//   final String closingStock;

//   UpdateStockEvent({
//     required this.stockId,
//     required this.brandName,
//     required this.labelName,
//     required this.lastStock,
//     required this.stockIn,
//     required this.totalStock,
//     required this.closingStock,
//   });
// }

class UpdateStockEvent extends SalesmanDashBoardEventClass {
  final String stockId;
  final String? brandName;
  final String? labelName;
  final String? lastStock;
  final String? stockIn;
  final String? totalStock;
  final String? closingStock;

  UpdateStockEvent({
    required this.stockId,
    this.brandName,
    this.labelName,
    this.lastStock,
    this.stockIn,
    this.totalStock,
    this.closingStock,
  });
}


class DeleteStockEvent extends SalesmanDashBoardEventClass {
  final String stockId;

  DeleteStockEvent({required this.stockId});
}


class UploadImageEvent extends SalesmanDashBoardEventClass {
  final String shopId;
  final List<File> imageList;

  UploadImageEvent({required this.shopId, required this.imageList});
}
