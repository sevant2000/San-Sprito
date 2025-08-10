import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://salesforce.sansprito.com/api';
  final String _contentType = 'application/x-www-form-urlencoded';

  Future<http.Response> login(
    String username,
    String password,
    String loginLocation,
    String deviceName,
  ) async {
    final url = Uri.parse('$_baseUrl/login');

    final headers = {'Content-Type': _contentType};

    final body = {
      'username': username,
      'password': password,
      'login_location': loginLocation,
      'device_name': deviceName,
    };

    return await http.post(
      url,
      headers: headers,
      body: body, // This will be encoded as x-www-form-urlencoded automatically
    );
  }

  Future<http.Response> dashBoardData(String userId) async {
    final url = Uri.parse('$_baseUrl/dashboard');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> wareHouserStockData(String userId) async {
    final url = Uri.parse('$_baseUrl/warehouse_stock');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> priorityStockData(String userId) async {
    final url = Uri.parse('$_baseUrl/priority_stock');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> shopListData(String userId) async {
    final url = Uri.parse('$_baseUrl/shop_stock');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> sellerTargetData(String userId) async {
    final url = Uri.parse('$_baseUrl/salesman_targets');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> assignedShopList(String userId) async {
    final url = Uri.parse('$_baseUrl/shop_list');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> sendMessage({
    required String loginId,
    // required List<String> adminIds,
    required String adminIds,
    required String messageContent,
  }) async {
    final url = Uri.parse('$_baseUrl/send_message');

    final headers = {'Content-Type': _contentType};

    final body = {
      'login_id': loginId,
      'admin_ids[]': adminIds,
      'message_content': messageContent,
    };

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> inboxMessageList(String userId) async {
    final url = Uri.parse('$_baseUrl/inbox');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': userId};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> saveRemark({
    required String shopId,
    required String message,
  }) async {
    final url = Uri.parse('$_baseUrl/save_remark');

    var request =
        http.MultipartRequest('POST', url)
          ..fields['shop_id'] = shopId
          ..fields['message'] = message;

    var streamedResponse = await request.send();

    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> createShopStock({
    required String loginId,
    required String shopId,
    required String loginLocation,
    required String deviceName,
  }) async {
    final url = Uri.parse('$_baseUrl/create_shop_stock');

    var request =
        http.MultipartRequest('POST', url)
          ..fields['login_id'] = loginId
          ..fields['shop_id'] = shopId
          ..fields['login_location'] = loginLocation
          ..fields['device_name'] = deviceName;

    var streamedResponse = await request.send();

    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> getProductBrand(String brandName) async {
    final url = Uri.parse('$_baseUrl/getBrands?brand_name=$brandName');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json', // Optional for GET
      },
    );

    return response;
  }

  Future<http.Response> saveShopStock({
    required int shopId,
    required List<Map<String, dynamic>> stockList,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/saveStock',
    ); // Replace with actual endpoint

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({"shop_id": shopId, "stock": stockList});

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> updateStock({
    required String stockId,
    required String brandName,
    required String labelName,
    required String lastStock,
    required String stockIn,
    required String totalStock,
    required String closingStock,
  }) async {
    final url = Uri.parse('$_baseUrl/updateStock');

    final request =
        http.MultipartRequest('POST', url)
          ..fields['stock_id'] = stockId
          ..fields['brand_name'] = brandName
          ..fields['label_name'] = labelName
          ..fields['last_stock'] = lastStock
          ..fields['stock_in'] = stockIn
          ..fields['total_stock'] = totalStock
          ..fields['closing_stock'] = closingStock;

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> deleteStock(String stockId) async {
    final url = Uri.parse('$_baseUrl/deleteStock?stock_id=$stockId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json', // Optional for GET
      },
    );

    return response;
  }

  Future<http.Response> logout(String loginId, String logoutLocation) async {
    final url = Uri.parse('$_baseUrl/logout');

    final headers = {'Content-Type': _contentType};

    final body = {'login_id': loginId, 'logout_location': logoutLocation};

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> uploadShopPhotos(
    String shopId,
    List<File> imageFiles,
  ) async {
    final url = Uri.parse('$_baseUrl/shop_photos');

    final request = http.MultipartRequest('POST', url);
    request.fields['shop_id'] = shopId;

    for (var file in imageFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('photos[]', file.path),
      );
    }

    // Optional: add headers if needed (e.g., Authorization)
    request.headers.addAll({'Content-Type': 'multipart/form-data'});

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  Future<http.Response> updateShopStatus({
    required String shopId,
  }) async {
    final url = Uri.parse('$_baseUrl/update_status');

    var request = http.MultipartRequest('POST', url)
      ..fields['shop_id'] = shopId;

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
