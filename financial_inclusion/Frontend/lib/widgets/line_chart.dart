import 'dart:math';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key}) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<Offset> _points = [];
  bool _isHoveringSwitch = false;

  @override
  void initState() {
    super.initState();
    _generateRandomPoints();
  }

  void _generateRandomPoints() {
    final random = Random();
    final newPoints = <Offset>[];
    for (int i = 0; i < 10; i++) {
      final x = i / 9;
      final y = random.nextDouble();
      newPoints.add(Offset(x, y));
    }
    _points = newPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed width set to 400
      width: 400, // <-- Added this line
      // A fixed height so the Stack has finite constraints.
      height: 220,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // 1) Chart background + paint
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: _SplineChartPainter(_points),
              ),
            ),
          ),

          // 2) Circle icon in top-left
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.show_chart,
                color: Colors.black,
              ),
            ),
          ),

          // 3) Year "Switch" in top-right (hoverable)
          Positioned(
            top: 8,
            right: 8,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHoveringSwitch = true),
              onExit: (_) => setState(() => _isHoveringSwitch = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isHoveringSwitch
                      ? Colors.grey.shade200
                      : Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '2024',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4) Labels in bottom-left: "Utilities" + "Report"
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Utilities',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Report',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple painter drawing a smoothed line with 40px "inner margin"
class _SplineChartPainter extends CustomPainter {
  final List<Offset> points;
  _SplineChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFFF4792A)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // We'll keep 40px margin all around, so the line won't touch edges
    const double margin = 40.0;
    final double width = size.width - 2 * margin;
    final double height = size.height - 2 * margin;

    if (width <= 0 || height <= 0) {
      // Not enough space to draw
      return;
    }

    // Convert normalized [0..1] points to the "inner" area
    final scaled = points.map(
      (p) => Offset(
        margin + p.dx * width,
        margin + (1 - p.dy) * height,
      ),
    ).toList();

    final path = Path()..moveTo(scaled[0].dx, scaled[0].dy);

    // Quadratic smoothing
    for (int i = 1; i < scaled.length - 1; i++) {
      final p0 = scaled[i];
      final p1 = scaled[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      final midY = (p0.dy + p1.dy) / 2;
      path.quadraticBezierTo(p0.dx, p0.dy, midX, midY);
    }
    path.lineTo(scaled.last.dx, scaled.last.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SplineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}
