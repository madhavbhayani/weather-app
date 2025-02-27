import 'package:weather/models/forecast_model.dart';

class WeatherModel {
  final double temperature;
  final String condition;
  final String icon;
  final String cityName;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int? pressure;
  final List<ForecastModel>? forecast;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.cityName,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    this.pressure,
    this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      cityName: json['name'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      forecast:
          null, // This will be populated separately from forecast API call,
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
    );
  }
}
