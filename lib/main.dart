import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/weather_viewmodel.dart';
import 'view/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherViewModel(),
      child: MaterialApp(
        title: '天气查询',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WeatherScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
