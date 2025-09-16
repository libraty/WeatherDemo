//天气数据模型
import 'dart:html';

class weatherModel {
  final String cityName;
  final String cityId;
  final double temperature;
  final String condition;
  final String iconUrl;
  final String humidity;
  final String windSpeed;
  final String updateTime;

  weatherModel(
      {required this.cityName,
      required this.cityId,
      required this.temperature,
      required this.condition,
      required this.iconUrl,
      required this.humidity,
      required this.windSpeed,
      required this.updateTime});

  factory weatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] != null && json['location'].isNotEmpty
        ? json['location'][0]
        : null;
    final now = json['now'];

    return weatherModel(
      cityName: location?['name'] ?? '未知城市',
      cityId: location?['id'] ?? '',
      temperature: double.parse(now?['temp'] ?? '0'),
      condition: now?['text'] ?? '未知',
      iconUrl:
          'https://a.hecdn.net/img/common/icon/202106d/${now?['icon']}.png',
      humidity: '${now?['humidity']}%',
      windSpeed: '${now?['windSpeed']}km/h',
      updateTime: json['updateTime'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'cityId': cityId,
      'temperature': temperature,
      'condition': condition,
      'iconUrl': iconUrl,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'updateTime': updateTime,
    };
  }

  static weatherModel fromCache(Map<String, dynamic> cache) {
    return weatherModel(
      cityName: cache['cityName'],
      cityId: cache['cityId'],
      temperature: cache['temperature'],
      condition: cache['condition'],
      iconUrl: cache['iconUrl'],
      humidity: cache['humidity'],
      windSpeed: cache['windSpeed'],
      updateTime: cache['updateTime'],
    );
  }
}
