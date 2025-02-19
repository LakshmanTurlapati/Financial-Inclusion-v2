import 'package:flutter/material.dart';

class AvgIncomeChartWidget extends StatelessWidget {
  const AvgIncomeChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 420,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // 1) Grid background (CustomPaint)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: _FadedGridPainter(),
              ),
            ),
          ),

          // 2) White circle in top-left with bar-chart icon
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.bar_chart,  // or FontAwesomeIcons.chartBar
                color: Colors.black,
                size: 20,
              ),
            ),
          ),

          // 3) The bars themselves
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Gray bar for 2023
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.2,  // bar thickness as fraction of width
                      heightFactor: 0.5, // 50% height, adjust as desired
                      alignment: Alignment.bottomCenter,
                      child: _BarWithLabel(
                        color: Colors.grey,
                        label: '2023',
                      ),
                    ),
                  ),

                  // Orange bar for 2024 (shift it horizontally)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.2,
                      heightFactor: 0.7, // taller bar
                      alignment: Alignment.bottomCenter,
                      child: _BarWithLabel(
                        color: const Color(0xFFF4792A),
                        label: '2024',
                      ),
                    ),
                  ),

                  // We shift the 2023 bar left, 2024 bar right by using `Transform`
                  // or we can place them in a Row. Here’s a row approach:
                ],
              ),
            ),
          ),
          // Instead of stacking, let's do a Row so the bars are side by side.
          // We'll override that last snippet:
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            bottom: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 2023 bar
                SizedBox(
                  width: 40,
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: _BarWithLabel(
                      color: Colors.grey,
                      label: '2023',
                    ),
                  ),
                ),
                // 2024 bar
                SizedBox(
                  width: 40,
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.7,
                    child: _BarWithLabel(
                      color: Color(0xFFF4792A),
                      label: '2024',
                    ),
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

/// A simple CustomPainter that draws the faded grid lines in the background.
class _FadedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 1.0;

    // We'll draw a 10x10 grid. Adjust as desired.
    const int rows = 10;
    const int cols = 10;

    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    // Draw vertical lines
    for (int c = 0; c <= cols; c++) {
      final x = c * cellWidth;
      // we can fade out near bottom:
      paint.color = Colors.grey.shade400.withOpacity(0.4);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (int r = 0; r <= rows; r++) {
      final y = r * cellHeight;
      paint.color = Colors.grey.shade400.withOpacity(0.4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_FadedGridPainter oldDelegate) => false;
}

/// A widget that draws a vertical bar with a circle label on top
/// The bar has a fade at the bottom.
class _BarWithLabel extends StatelessWidget {
  final Color color;
  final String label;
  const _BarWithLabel({Key? key, required this.color, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // The bar itself
        Container(
          width: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(1.0), // fully opaque at the top
                color.withOpacity(0.0), // fade out at the bottom
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        // The circle label at the top
        Positioned(
          top: 0,
          left: -14, // shift to center the circle over the bar
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
