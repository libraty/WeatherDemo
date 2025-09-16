import 'dart:convert';

import 'package:weatherdemo/core/network/api_client.dart';
import '../core/network/api_client.dart';
import '../core/constants.dart';
import '../core/utils/cache_manager.dart';
import '../model/weather_model.dart';

class WeatherRepository {
  final ApiClient _apiClient = ApiClient(baseUrl: '');
  final CacheManager _cacheManager = CacheManager();

  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final cachedData =
          await _cacheManager.getData('${AppConstants.cachekey}_$cityName');
      if (cachedData != null) {
        return WeatherModel.fromCache(cachedData);
      }

      final locationRes = await _apiClient.get(
        ApiConstants.cityLookup,
        params: {'location': cityName},
      );

      if (locationRes['location'] == null || locationRes['location'].isEmpty) {
        throw Exception('城市未找到');
      }
      final String cityId = locationRes['location'][0]['id'];

      final weatherRes = await ApiClient(baseUrl: ApiConstants.baseUrl)
          .get(ApiConstants.weatherNow, params: {'location': cityId});

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
      rethrow;
    }
  }
}
