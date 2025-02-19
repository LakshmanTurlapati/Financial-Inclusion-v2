import 'dart:math' as math;
import 'package:flutter/material.dart';

class BackgroundScreen extends StatefulWidget {
  const BackgroundScreen({Key? key}) : super(key: key);

  @override
  _BackgroundScreenState createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  // You can store random offsets or angles for the blobs here
  // if you want them to be truly random, or generate them on the fly.
  Offset orangeCenter = const Offset(100, 200);
  Offset blackCenter  = const Offset(200, 400);

  @override
  void initState() {
    super.initState();

    // AnimationController for smooth infinite “breathing”-like motion
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true); // The animation goes forward and backward

    // A simple tween from 0 to 1, we’ll use it to offset positions
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No default background color—our CustomPaint will do the painting.
      body: Stack(
        children: [
          // 1) Paint the background + moving blobs
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: BlobsPainter(
                  animationValue: _animation.value,
                  orangeCenter: orangeCenter,
                  blackCenter: blackCenter,
                ),
              );
            },
          ),

          // 2) Overlay a noise image (optional). 
          //    Adjust opacity to taste for the grainy effect.
          Positioned.fill(
            child: Opacity(
              opacity: 0.08, // Tweak for heavier/lighter noise
              child: Image.asset(
                'assets/noise.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 3) Place the FI_dark.png logo in the top-left corner
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/FI_dark.png',
                height: 40, // or any size you prefer
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A CustomPainter to paint a white background with two fuzzy “blob” spots:
/// - One orange (#F4792A)
/// - One black (#000000)
/// Both are painted with a radial gradient to appear soft-edged.
class BlobsPainter extends CustomPainter {
  final double animationValue;
  final Offset orangeCenter;
  final Offset blackCenter;

  BlobsPainter({
    required this.animationValue,
    required this.orangeCenter,
    required this.blackCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill the background with white
    final rect = Offset.zero & size;
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(rect, bgPaint);

    // We’ll animate the blob centers a bit
    // (You can randomize direction, distance, or amplitude however you like.)
    final animOffset = math.sin(animationValue * math.pi * 2) * 40; // +/- 40 px

    // Move orange blob’s center in a subtle wave
    final offsetOrange = Offset(
      orangeCenter.dx + animOffset,
      orangeCenter.dy - animOffset * 0.5,
    );

    // Move black blob’s center in a subtle wave (slightly out of phase)
    final offsetBlack = Offset(
      blackCenter.dx - animOffset * 0.7,
      blackCenter.dy + animOffset * 0.5,
    );

    // Paint the orange blob with a radial gradient
    // radius can be larger than actual circle to get big soft edges.
    final orangeGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.4, // tweak
      colors: [
        const Color(0xFFF4792A).withOpacity(0.8),
        const Color(0x00F4792A), // fully transparent at edge
      ],
    );

    final orangePaint = Paint()
      ..shader = orangeGradient.createShader(
        Rect.fromCircle(center: offsetOrange, radius: 200),
      );

    canvas.drawCircle(offsetOrange, 200, orangePaint);

    // Paint the black blob with a radial gradient for soft edges
    final blackGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.3, // tweak
      colors: [
        Colors.black.withOpacity(0.7),
        Colors.black.withOpacity(0.0),
      ],
    );

    final blackPaint = Paint()
      ..shader = blackGradient.createShader(
        Rect.fromCircle(center: offsetBlack, radius: 180),
      );

    canvas.drawCircle(offsetBlack, 180, blackPaint);
  }

  @override
  bool shouldRepaint(covariant BlobsPainter oldDelegate) {
    // Repaint whenever animationValue or centers change
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.orangeCenter != orangeCenter ||
           oldDelegate.blackCenter  != blackCenter;
  }
}
