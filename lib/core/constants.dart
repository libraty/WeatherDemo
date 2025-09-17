//常量定义

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get geoApiUrl => dotenv.env['GEO_API_URL'] ?? '';
  static String get apikey => dotenv.env['API_KEY'] ?? '';

  static const String weatherNow = '/weather/now';
  static const String cityLookup = '/city/lookup';
}

class AppConstants {
  static const String cachekey = 'weather_cache';
  static const Duration CacheDuration = Duration(hours: 1);
}
