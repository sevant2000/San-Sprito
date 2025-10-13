import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // final String _baseUrl = 'https://salesforce.sansprito.com/api';
  final String _baseUrl = 'https://rajasthan-salesforce.sansprito.com/api';
  final String _contentType = 'application/x-www-form-urlencoded';

  /// 🔹 Helper method to debugPrint API details for debugging
  void _printApiDetails(String endpoint, [Map<String, dynamic>? body]) {
    final fullUrl = '$_baseUrl/$endpoint';
    debugPrint('\n📡 API CALL → $fullUrl');
    if (body != null && body.isNotEmpty) {
      debugPrint('📦 Request Body → $body');
    }
    debugPrint('--------------------------------------------');
  }

  Future<http.Response> login(
    String username,
    String password,
    String loginLocation,
    String deviceName,
  ) async {
    const endpoint = 'login';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {
      'username': username,
      'password': password,
      'login_location': loginLocation,
      'device_name': deviceName,
    };

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> dashBoardData(String userId) async {
    const endpoint = 'dashboard';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> wareHouserStockData(String userId) async {
    const endpoint = 'warehouse_stock';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> priorityStockData(String userId) async {
    const endpoint = 'priority_stock';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> shopListData(String userId) async {
    const endpoint = 'shop_stock';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> sellerTargetData(String userId) async {
    const endpoint = 'salesman_targets';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> assignedShopList(String userId) async {
    const endpoint = 'shop_list';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> sendMessage({
    required String loginId,
    required String adminIds,
    required String messageContent,
  }) async {
    const endpoint = 'send_message';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {
      'login_id': loginId,
      'admin_ids[]': adminIds,
      'message_content': messageContent,
    };

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> inboxMessageList(String userId) async {
    const endpoint = 'inbox';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': userId};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> saveRemark({
    required String shopId,
    required String message,
  }) async {
    const endpoint = 'save_remark';
    final url = Uri.parse('$_baseUrl/$endpoint');

    _printApiDetails(endpoint, {'shop_id': shopId, 'message': message});

    final request =
        http.MultipartRequest('POST', url)
          ..fields['shop_id'] = shopId
          ..fields['message'] = message;

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> createShopStock({
    required String loginId,
    required String shopId,
    required String loginLocation,
    required String deviceName,
  }) async {
    const endpoint = 'create_shop_stock';
    final url = Uri.parse('$_baseUrl/$endpoint');

    _printApiDetails(endpoint, {
      'login_id': loginId,
      'shop_id': shopId,
      'login_location': loginLocation,
      'device_name': deviceName,
    });

    final request =
        http.MultipartRequest('POST', url)
          ..fields['login_id'] = loginId
          ..fields['shop_id'] = shopId
          ..fields['login_location'] = loginLocation
          ..fields['device_name'] = deviceName;

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> getProductBrand(String brandName) async {
    const endpoint = 'getBrands';
    final url = Uri.parse('$_baseUrl/$endpoint?brand_name=$brandName');

    _printApiDetails(endpoint, {'brand_name': brandName});

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<http.Response> saveShopStock({
    required int shopId,
    required List<Map<String, dynamic>> stockList,
  }) async {
    const endpoint = 'saveStock';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'shop_id': shopId, 'stock': stockList});

    _printApiDetails(endpoint, {
      'shop_id': shopId,
      'stock_count': stockList.length,
    });
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> updateStock({
    required String stockId,
    String? brandName,
    String? labelName,
    String? lastStock,
    String? stockIn,
    String? totalStock,
    String? closingStock,
  }) async {
    const endpoint = 'updateStock';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final fields = {'stock_id': stockId};
    if (brandName != null) fields['brand_name'] = brandName;
    if (labelName != null) fields['label_name'] = labelName;
    if (lastStock != null) fields['last_stock'] = lastStock;
    if (stockIn != null) fields['stock_in'] = stockIn;
    if (totalStock != null) fields['total_stock'] = totalStock;
    if (closingStock != null) fields['closing_stock'] = closingStock;

    _printApiDetails(endpoint, fields);

    final request = http.MultipartRequest('POST', url)..fields.addAll(fields);
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> deleteStock(String stockId) async {
    const endpoint = 'deleteStock';
    final url = Uri.parse('$_baseUrl/$endpoint?stock_id=$stockId');

    _printApiDetails(endpoint, {'stock_id': stockId});

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<http.Response> logout(String loginId, String logoutLocation) async {
    const endpoint = 'logout';
    final url = Uri.parse('$_baseUrl/$endpoint');

    final headers = {'Content-Type': _contentType};
    final body = {'login_id': loginId, 'logout_location': logoutLocation};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> uploadShopPhotos(
    String shopId,
    List<File> imageFiles,
  ) async {
    const endpoint = 'shop_photos';
    final url = Uri.parse('$_baseUrl/$endpoint');

    _printApiDetails(endpoint, {
      'shop_id': shopId,
      'photo_count': imageFiles.length,
    });

    final request = http.MultipartRequest('POST', url)
      ..fields['shop_id'] = shopId;
    for (var file in imageFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('photos[]', file.path),
      );
    }

    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> updateShopStatus({required String shopId}) async {
    const endpoint = 'update_status';
    final url = Uri.parse('$_baseUrl/$endpoint');

    _printApiDetails(endpoint, {'shop_id': shopId});

    final request = http.MultipartRequest('POST', url)
      ..fields['shop_id'] = shopId;
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  /// Promotion Stuff

  Future<http.Response> createPromotion({
    required String shopId,
    required String salesmanId,
    required String brandName,
    required String noOfBottles,
    required String categoryName,
  }) async {
    const endpoint = 'createPromotion';
    final url = Uri.parse('$_baseUrl/$endpoint');

    _printApiDetails(endpoint, {
      'shop_id': shopId,
      'salesman_id': salesmanId,
      'brand_name': brandName,
      'no_of_bottles': noOfBottles,
      'categoryName': categoryName,
    });

    var request =
        http.MultipartRequest('POST', url)
          ..fields['shop_id'] = shopId
          ..fields['salesman_id'] = salesmanId
          ..fields['brand_name'] = brandName
          ..fields['no_of_bottles'] = noOfBottles
          ..fields['categoryName'] = categoryName;

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> getPromotionList() async {
    const endpoint = 'promotion_list';
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {'Content-Type': _contentType};

    _printApiDetails(endpoint);
    return await http.post(url, headers: headers);
  }

  Future<http.Response> updatePromotion({
    required String brandName,
    required int noOfBottles,
    required int promotionId,
  }) async {
    const endpoint = 'updatePromotion';
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {'Content-Type': _contentType};
    final body = {
      'brand_name': brandName,
      'no_of_bottles': noOfBottles.toString(),
      'promotion_id': promotionId.toString(),
    };

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> deletePromotion({required int promotionId}) async {
    const endpoint = 'deletePromotion';
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {'Content-Type': _contentType};
    final body = {'promotion_id': promotionId.toString()};

    _printApiDetails(endpoint, body);
    return await http.post(url, headers: headers, body: body);
  }
}
