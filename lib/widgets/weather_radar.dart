import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeatherRadar extends StatefulWidget {
  final double size;
  final Color color;

  const WeatherRadar({
    super.key,
    this.size = 200,
    this.color = Colors.blue,
  });

  @override
  State<WeatherRadar> createState() => _WeatherRadarState();
}

class _WeatherRadarState extends State<WeatherRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _RadarPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadarPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw circles
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * (i / 3),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color.withOpacity(0.3),
      );
    }

    // Draw scanning line
    final scanPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0),
          color.withOpacity(0.5),
        ],
        stops: const [0.0, 1.0],
        startAngle: 0,
        endAngle: math.pi * 2,
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, scanPaint);
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) => true;
}
