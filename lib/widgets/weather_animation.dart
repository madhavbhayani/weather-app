import 'package:flutter/material.dart';
import '../utils/weather_type.dart';

class WeatherAnimation extends StatefulWidget {
  final WeatherType weatherType;
  final double size;

  const WeatherAnimation({
    super.key,
    required this.weatherType,
    this.size = 200,
  });

  @override
  State<WeatherAnimation> createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends State<WeatherAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.size,
          width: widget.size,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.weatherType == WeatherType.sunny) _buildSun(),
              if (widget.weatherType == WeatherType.rainy) _buildRain(),
              if (widget.weatherType == WeatherType.cloudy) _buildCloud(),
              if (widget.weatherType == WeatherType.snowy) _buildSnow(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSun() {
    return Transform.translate(
      offset: Offset(0, _animation.value),
      child: Container(
        width: widget.size * 0.6,
        height: widget.size * 0.6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRain() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud, size: widget.size * 0.5, color: Colors.white),
        SizedBox(
          height: widget.size * 0.3,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Transform.translate(
                offset: Offset(0, (index.isEven ? 1 : -1) * _animation.value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 2,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCloud() {
    return Transform.translate(
      offset: Offset(_animation.value, 0),
      child: Icon(
        Icons.cloud,
        size: widget.size * 0.7,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Widget _buildSnow() {
    return Stack(
      children: List.generate(
        10,
        (index) => Transform.translate(
          offset: Offset(
            (index - 5) * 15.0,
            _animation.value * (index.isEven ? 1 : -1),
          ),
          child: Icon(
            Icons.ac_unit,
            size: widget.size * 0.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
