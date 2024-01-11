import 'package:flutter/material.dart';
import 'package:weather_app_2/screens/weather_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SafeArea(child: WeatherScreen()),
    );
  }
}
