//缓存管理

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherdemo/core/constants.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  Future<void> saveData(String key, dynamic data, {Duration? duration}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
      'duration':
          duration?.inMicroseconds ?? AppConstants.CacheDuration.inMicroseconds,
    };
    prefs.setString(key, json.encode(cacheData));
  }

  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheString = prefs.getString(key);

    if (cacheString != null) {
      final cacheData = json.decode(cacheString);
      final int timestamp = cacheData['timestamp'];
      final int duration = cacheData['duration'];

      if (DateTime.now().microsecondsSinceEpoch - timestamp < duration) {
        return cacheData['data'];
      } else {
        prefs.remove(key);
      }
    }
    return null;
  }

  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
