import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String _apiKey =
      '31d3411ebfa2738ea463da1f04095084'; // Replace with your API key

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel> getWeather() async {
    try {
      final position = await getCurrentLocation();

      // Get current weather with sunrise/sunset
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'));

      if (weatherResponse.statusCode == 200) {
        final weatherData = jsonDecode(weatherResponse.body);

        // Get 3-day forecast
        final forecastResponse = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'));

        if (forecastResponse.statusCode == 200) {
          final forecastData = jsonDecode(forecastResponse.body);
          final List<ForecastModel> forecast = [];

          // Get one forecast per day for next 3 days
          final Map<String, bool> dates = {};
          int daysCount = 0;

          for (var item in forecastData['list']) {
            final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
            final dateString = DateFormat('yyyy-MM-dd').format(date);

            if (!dates.containsKey(dateString) && daysCount < 3) {
              dates[dateString] = true;
              forecast.add(ForecastModel.fromJson(item));
              daysCount++;
            }
          }

          return WeatherModel(
            temperature: weatherData['main']['temp'].toDouble(),
            condition: weatherData['weather'][0]['main'],
            icon: weatherData['weather'][0]['icon'],
            cityName: weatherData['name'],
            feelsLike: weatherData['main']['feels_like'].toDouble(),
            humidity: weatherData['main']['humidity'],
            windSpeed: weatherData['wind']['speed'].toDouble(),
            pressure: weatherData['main']['pressure'],
            forecast: forecast,
            sunrise: DateTime.fromMillisecondsSinceEpoch(
                weatherData['sys']['sunrise'] * 1000),
            sunset: DateTime.fromMillisecondsSinceEpoch(
                weatherData['sys']['sunset'] * 1000),
          );
        }

        throw Exception('Failed to load forecast data');
      }
      throw Exception('Failed to load weather data');
    } catch (e) {
      throw Exception('Error getting weather: $e');
    }
  }
}
