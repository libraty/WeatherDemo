//常量定义
class ApiConstants {
  static const String baseUrl = 'https://mh59fby3va.re.qweatherapi.com/v7/';
  static const String geoApiUrl =
      'https://mh59fby3va.re.qweatherapi.com/geo/v2/';
  static const String apikey = '923757dbb0534dedabba25c6e2c25835';

  static const String weatherNow = '$baseUrl/weahter/now';
  static const String cityLookup = '$geoApiUrl/city/lookip';
}

class AppConstants {
  static const String cachekey = 'weather_cache';
  static const Duration CacheDuration = Duration(hours: 1);
}
