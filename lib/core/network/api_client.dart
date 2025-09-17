//网络请求封装
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:weatherdemo/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:weatherdemo/core/network/api_exception.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'key': ApiConstants.apikey,
        'lang': 'zh',
        ...?params,
      };
      final Uri uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );
      print('查询的url是: ${uri}');
      final res = await http.get(uri).timeout(const Duration(seconds: 100));
      if (res.statusCode == 200) {
        Uint8List responseBodyBytes = res.bodyBytes;
        String decodedBody = utf8.decode(responseBodyBytes);
        final Map<String, dynamic> data = json.decode(decodedBody);
        if (data['code'] == '200') {
          return data;
        } else {
          throw ApiException(
              data['message'] ?? '未知错误', int.parse(data['code']));
        }
      } else {
        throw ApiException('HTTP error:${res.statusCode}', res.statusCode);
      }
    } on http.ClientException catch (e) {
      throw ApiException('NetWork error: $e', 500);
    } on Exception catch (e) {
      throw ApiException('NetWork error: $e', 500);
    }
  }
}
