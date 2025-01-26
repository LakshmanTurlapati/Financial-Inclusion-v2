import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScoreGauge extends StatefulWidget {
  final int score;
  final int maxScore;

  /// Pass a [score] out of [maxScore]. Defaults to 614/900.
  /// Animates from 0..(score/maxScore).
  const ScoreGauge({
    Key? key,
    this.score = 314,
    this.maxScore = 900,
  }) : super(key: key);

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fractionAnimation;

  @override
  void initState() {
    super.initState();

    final double endFraction =
        (widget.score / widget.maxScore).clamp(0.0, 1.0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fractionAnimation = Tween<double>(begin: 0.0, end: endFraction).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animating
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Outer container is black and circular, 220x220 with some padding.
    return Container(
      width: 250,
      height: 250,
      padding: const EdgeInsets.all(10), // margin-like padding
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black, // black background
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Draw arcs: orange fraction, then mid-gray, then dark-gray
          AnimatedBuilder(
            animation: _fractionAnimation,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(230, 230),
                painter: _ThreeArcPainter(fraction: _fractionAnimation.value),
              );
            },
          ),

          // Center text: "614 pts" on one line, then "Score" below
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // "614 pts" in one line, using a RichText for different font sizes/colors
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.score}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: ' pts',
                      style: const TextStyle(
                        fontSize: 14, // roughly half of 28
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Score',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7A7A7A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Paints three arcs in a full circle (each separated by small gaps):
///   1) ORANGE for fraction portion
///   2) MID-GRAY for half of leftover
///   3) DARK-GRAY for the remaining half
/// All arcs start at 270° (top) and proceed clockwise with round ends.
class _ThreeArcPainter extends CustomPainter {
  final double fraction; // 0..1

  _ThreeArcPainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final double fullCircle = 2 * math.pi;

    // We'll compute how many radians the orange arc covers,
    // then the leftover is split evenly between mid-gray & dark-gray,
    // with 2 gap segments (3px each) in between arcs.
    final double orangeArcAngle = fraction * fullCircle;
    final double leftoverAngle = fullCircle - orangeArcAngle;
    final double halfLeftover = leftoverAngle / 2;

    // Gap logic: each gap ~ 3 px along outer circumference => gapAngle in radians
    final double gapPx = 3;
    final double gapAngle = gapPx / (radius - strokeWidth / 2);

    // We draw arcs in the order: ORANGE → MID-GRAY → DARK-GRAY,
    // all starting at 270° = -π/2, going clockwise.
    final double startAngle = math.pi;

    // Arc #1 (Orange)
    final orangePaint = Paint()
      ..color = const Color(0xFFF4792A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // If fraction > 0, draw orange arc
    if (orangeArcAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        // We subtract half the gap so the arc ends with a small space before next arc
        math.max(0, orangeArcAngle - (gapAngle / 2)),
        false,
        orangePaint,
      );
    }

    // Arc #2 (Mid-Gray)
    // Start after the orange arc + half gap
    final double midGrayStart = startAngle + orangeArcAngle + (gapAngle / 2);
    final double midGraySweep = math.max(0, halfLeftover - (gapAngle / 2));

    final midGrayPaint = Paint()
      ..color = const Color(0xFF7A7A7A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (fraction < 1) {
      // There's leftover
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        midGrayStart,
        midGraySweep,
        false,
        midGrayPaint,
      );
    }

    // Arc #3 (Dark-Gray)
    // Start after mid-gray arc + half gap
    final double darkGrayStart = midGrayStart + midGraySweep + gapAngle / 2;
    // The remainder
    final double darkGraySweep = math.max(0, halfLeftover - (gapAngle / 2));

    final darkGrayPaint = Paint()
      ..color = const Color(0xFF47474A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (fraction < 1) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        darkGrayStart,
        darkGraySweep,
        false,
        darkGrayPaint,
      );
    }
  }

  double get strokeWidth => 16.0;

  @override
  bool shouldRepaint(_ThreeArcPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
