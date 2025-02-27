import 'package:flutter/material.dart';
import '../utils/weather_type.dart';

class WeatherScene extends StatelessWidget {
  final WeatherType weather;

  const WeatherScene({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: _buildWeatherAnimation(),
    );
  }

  Widget _buildWeatherAnimation() {
    switch (weather) {
      case WeatherType.rainy:
        return Container(
          // Add rain animation
          color: Colors.transparent,
          child: const Center(
              child: Icon(Icons.cloud, size: 50, color: Colors.white)),
        );
      case WeatherType.snowy:
        return Container(
          // Add snow animation
          color: Colors.transparent,
          child: const Center(
              child: Icon(Icons.ac_unit, size: 50, color: Colors.white)),
        );
      case WeatherType.cloudy:
        return Container(
          // Add cloud animation
          color: Colors.transparent,
          child: const Center(
              child: Icon(Icons.cloud, size: 50, color: Colors.white)),
        );
      case WeatherType.sunny:
        return Container(
          // Add sun animation
          color: Colors.transparent,
          child: const Center(
              child: Icon(Icons.wb_sunny, size: 50, color: Colors.white)),
        );
    }
  }
}
