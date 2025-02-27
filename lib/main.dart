import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
import 'models/weather_model.dart';
import 'models/forecast_model.dart';
import 'services/weather_service.dart';
import 'utils/weather_utils.dart';
import 'package:animate_do/animate_do.dart';
import 'widgets/weather_grid.dart';
import 'widgets/sun_graph.dart';
import 'utils/weather_type.dart';
import 'widgets/weather_animation.dart';
import 'widgets/forecast_card.dart';
import 'widgets/weather_radar.dart';
import 'widgets/air_quality_card.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  int _selectedForecastIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await _weatherService.getWeather();
      setState(() => _weather = weather);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                WeatherUtils.getBackgroundGradient('clear', TimeOfDay.now()),
          ),
        ),
        child: const Center(
          child: SpinKitPulsingGrid(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: WeatherUtils.getBackgroundGradient(
              _weather!.condition,
              TimeOfDay.now(),
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Weather Animation overlay
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: _buildWeatherAnimation(_weather!.condition),
                ),

                // Main weather info
                FadeInDown(
                  child: Text(
                    _weather!.cityName,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Temperature and condition
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Text(
                        '${_weather!.temperature.round()}°C',
                        style: const TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _weather!.condition,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Weather parameters grid
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: WeatherGrid(
                    weatherData: {
                      'Feels Like': '${_weather!.feelsLike.round()}°C',
                      'Humidity': '${_weather!.humidity}%',
                      'Wind': '${_weather!.windSpeed} m/s',
                      'Pressure': _weather!.pressure != null
                          ? '${_weather!.pressure} hPa'
                          : 'N/A',
                    },
                  ),
                ),

                // Sunrise/Sunset graph
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 250,
                      maxHeight: 300,
                    ),
                    child: SunGraph(
                      sunrise: _weather!.sunrise,
                      sunset: _weather!.sunset,
                    ),
                  ),
                ),

                // Forecast section
                if (_weather!.forecast?.isNotEmpty ?? false)
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    child: _buildForecastSection(_weather!.forecast!),
                  ),
            SizedBox(height: 20),
                // Add Weather Radar
                FadeInUp(
                  delay: const Duration(milliseconds: 1300),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Weather Radar',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: WeatherRadar(
                          size: 200,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add Air Quality Card
                FadeInUp(
                  delay: const Duration(milliseconds: 1400),
                  child: const AirQualityCard(aqi: 75),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: _loadWeather,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildWeatherAnimation(String condition) {
    return WeatherAnimation(
      weatherType: WeatherType.fromString(condition),
      size: MediaQuery.of(context).size.width * 0.5,
    );
  }

  Widget _buildForecastSection(List<ForecastModel> forecast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '3-Day Forecast',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              return ForecastCard(
                forecast: forecast[index],
                isSelected: _selectedForecastIndex == index,
                onTap: () => setState(() => _selectedForecastIndex = index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(ForecastModel forecast) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE').format(forecast.date),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Icon(
            _getWeatherIcon(forecast.condition),
            color: Colors.white,
          ),
          Text(
            '${forecast.temp.round()}°C',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return WeatherIcons.day_sunny;
      case 'clouds':
        return WeatherIcons.cloudy;
      case 'rain':
        return WeatherIcons.rain;
      case 'snow':
        return WeatherIcons.snow;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'drizzle':
        return WeatherIcons.showers;
      case 'mist':
      case 'fog':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.day_sunny;
    }
  }
}
