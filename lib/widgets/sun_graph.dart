import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SunGraph extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunGraph({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: 16,
      ),
      height: 250, // Fixed height
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          const Text(
            'Sunrise & Sunset',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Colors.orange.withOpacity(0.7),
                    Colors.orange.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('HH:mm').format(sunrise),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          } else if (value == 12) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('HH:mm').format(sunset),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSunPath(),
                      isCurved: true,
                      color: Colors.white,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.orange,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withOpacity(0.3),
                            Colors.orange.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 12,
                  minY: 0,
                  maxY: 6,
                ),
              ),
            ),
          ),
          SizedBox(height: 16), // Add fixed spacing
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSunInfo(Icons.wb_sunny, 'Sunrise', sunrise),
                _buildSunInfo(
                  Icons.nightlight_round,
                  'Sunset',
                  sunset,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSunPath() {
    List<FlSpot> spots = [];
    for (int i = 0; i <= 12; i++) {
      double y = -0.1 * (i - 6) * (i - 6) + 5;
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  Widget _buildSunInfo(IconData icon, String label, DateTime time) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        Text(
          DateFormat('HH:mm').format(time),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
