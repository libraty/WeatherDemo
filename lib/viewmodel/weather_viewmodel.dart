import 'package:flutter/material.dart';
import 'package:weatherdemo/model/weather_model.dart';
import 'package:weatherdemo/repository/weather_repository.dart';

class WeatherViewModel with ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();

  WeatherModel? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';

  WeatherModel? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _weatherData = await _repository.getWeather(cityName);
    } catch (e) {
      // String Msg;
      print('WeatherViewModel 错误: $e');
      _errorMessage = '城市查询异常，请确认城市名称';
      _weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
