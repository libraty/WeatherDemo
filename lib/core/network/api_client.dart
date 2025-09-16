//网络请求封装
import 'dart:convert';
import 'dart:math';

import 'package:weatherdemo/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:weatherdemo/core/network/api_exception.dart';

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);
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
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        if (data['code'] == '200') {
          return data;
        } else {
          throw ApiException(
              int.parse(data['code']) as String, data['message'] ?? '未知错误');
        }
      } else {
        throw ApiException(
            res.statusCode as String, 'HTTP error: ${res.statusCode}' as int);
      }
    } on http.ClientException catch (e) {
      throw ApiException(0 as String, 'NetWork error: $e' as int);
    } on Exception catch (e) {
      throw ApiException(0 as String, 'NetWork error: $e' as int);
    }
  }
}
