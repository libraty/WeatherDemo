import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:weatherdemo/view/widgets/loading_indicator.dart';
import 'package:weatherdemo/viewmodel/weather_viewmodel.dart';
import './widgets/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('天气查询', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 20),
              Expanded(child: _buildWeatherContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: '请输入城市名称',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (value) => _searchWeather(context),
            ),
          ),
          IconButton(
            onPressed: () => _searchWeather(context),
            icon: const Icon(
              Icons.search,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const LoadingIndicator();
        }

        if (viewModel.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  viewModel.errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => viewModel.clearError(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (viewModel.weatherData != null) {
          return WeatherCard(weather: viewModel.weatherData!);
        }

        return const Center(
          child: Text(
            '请输入城市名称查询天气',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      },
    );
  }

  void _searchWeather(BuildContext context) {
    if (_cityController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: '请输入城市名称',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final viewModel = Provider.of<WeatherViewModel>(context, listen: false);
    viewModel.fetchWeather(_cityController.text);
  }
}
