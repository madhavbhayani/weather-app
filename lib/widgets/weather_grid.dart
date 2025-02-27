import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WeatherGrid extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherGrid({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, dynamic>> items = weatherData.entries.toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 2,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIcon(items[index].key),
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          items[index].value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          items[index].key,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getIcon(String parameter) {
    switch (parameter.toLowerCase()) {
      case 'humidity':
        return WeatherIcons.humidity;
      case 'wind':
        return WeatherIcons.strong_wind;
      case 'feels like':
        return WeatherIcons.thermometer;
      case 'pressure':
        return WeatherIcons.barometer;
      default:
        return Icons.info_outline;
    }
  }
}
