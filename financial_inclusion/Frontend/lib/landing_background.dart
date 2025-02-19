import 'dart:math';
import 'package:flutter/material.dart';

class LoginBackground extends StatefulWidget {
  const LoginBackground({super.key});

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<Color> _backgroundColors = [
    const Color(0xFF29333c),
    Colors.black,
  ];

  final List<Color> _auroraColors = [
    const Color(0xFFa97987),
    const Color(0xFF27a6be),
    const Color(0xFF3e708e),
    const Color(0xFF695068),
    const Color(0xFF38546b),
    const Color(0xFF298fa1),
    const Color(0xFF296579),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 55),
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
        return SizedBox(
          width: MediaQuery.of(context).size.width * 1.5,
          height: MediaQuery.of(context).size.height * 1.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2.0,
                colors: _backgroundColors,
                stops: const [0.0, 1.0],
              ),
            ),
            child: CustomPaint(
              painter: _AuroraPainter(
                animation: _controller,
                auroraColors: _auroraColors,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Color> auroraColors;
  static const int _waveCount = 4;
  static const double _auroraWidthFactor = 1.25;

  _AuroraPainter({
    required this.animation,
    required this.auroraColors,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final auroraHalfWidth = (size.width * _auroraWidthFactor) / 2;
    final leftBound = centerX - auroraHalfWidth;
    final rightBound = centerX + auroraHalfWidth;

    for (int i = 0; i < _waveCount; i++) {
      _drawAuroraWave(
        canvas,
        size,
        index: i,
        leftBound: leftBound,
        rightBound: rightBound,
      );
    }
  }

  void _drawAuroraWave(
    Canvas canvas,
    Size size, {
    required int index,
    required double leftBound,
    required double rightBound,
  }) {
    final path = Path();
    final waveHeight = size.height * (0.15 + index * 0.03) * 1.25;
    final baseY = size.height * 0.2;
    final phase = animation.value * 2 * pi * (1 + index * 0.3);
    const frequency = 0.003;
    const step = 8.0;

    for (double x = leftBound; x <= rightBound; x += step) {
      final sin1 = sin(x * frequency + phase);
      final sin2 = 0.5 * sin(x * frequency * 2 - phase / 2);
      final offsetY = (sin1 + sin2) * waveHeight;
      final y = baseY + offsetY;

      x == leftBound ? path.moveTo(x, y) : path.lineTo(x, y);
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 95
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90)
      ..blendMode = BlendMode.plus;

    final waveColors = _shiftColors(index).map((color) {
      return color.withOpacity(0.9);
    }).toList();

    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: waveColors,
      stops: const [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0],
    ).createShader(Rect.fromLTWH(leftBound, 0, rightBound - leftBound, size.height));

    canvas.drawPath(path, paint);
  }

  List<Color> _shiftColors(int index) {
    final offset = index % auroraColors.length;
    return List.generate(auroraColors.length, (i) {
      return auroraColors[(i + offset) % auroraColors.length];
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
