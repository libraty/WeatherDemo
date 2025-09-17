import 'dart:convert';

import 'package:weatherdemo/core/network/api_client.dart';
import '../core/constants.dart';
import '../core/network/api_exception.dart';
import '../core/utils/cache_manager.dart';
import '../model/weather_model.dart';

class WeatherRepository {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiConstants.geoApiUrl);
  final CacheManager _cacheManager = CacheManager();

  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final cachedData =
          await _cacheManager.getData('${AppConstants.cachekey}_$cityName');
      print('从本地拿到信息：${cachedData}');
      if (cachedData != null) {
        return WeatherModel.fromCache(cachedData);
      }

      // final cityLookupUri = Uri.parse(ApiConstants.cityLookup).replace(
      //   queryParameters: {'location': cityName, 'key': ApiConstants.apikey},
      // );
      // print('城市查询url:${cityLookupUri}');

      final locationRes = await _apiClient.get(
        ApiConstants.cityLookup,
        params: {'location': cityName, 'key': ApiConstants.apikey},
      );
      print('拿到城市数据：$locationRes');

      if (locationRes['location'] == null || locationRes['location'].isEmpty) {
        throw ApiException('城市未找到', 404);
      }
      final String cityId = locationRes['location'][0]['id'];

      // final weatherNowUri = Uri.parse(ApiConstants.weatherNow).replace(
      //   queryParameters: {'location': cityId, 'key': ApiConstants.apikey},
      // );
      // print('天气查询URL: ${weatherNowUri}');

      final weatherRes = await ApiClient(baseUrl: ApiConstants.baseUrl).get(
          ApiConstants.weatherNow,
          params: {'location': cityId, 'key': ApiConstants.apikey});
      print('拿到天气数据：$weatherRes');

      final combinedData = <String, dynamic>{
        ...weatherRes,
        'location': locationRes['location'],
      };

      final weather = WeatherModel.fromJson(combinedData);

      await _cacheManager.saveData(
        '${AppConstants.cachekey}_$cityName',
        weather.toJson(),
        duration: AppConstants.CacheDuration,
      );

      return weather;
    } catch (e) {
      print('WeatherRepository 错误: $e');
      rethrow;
    }
  }
}
