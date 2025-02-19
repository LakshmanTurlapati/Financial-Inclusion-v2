import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OverdueGridWidget extends StatelessWidget {
  const OverdueGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Common colors
    const Color bgColor = Color(0xFFEDEDED);    // container background
    const Color iconCircleColor = Colors.white; // circle behind the clock icon
    const Color orangeDot = Color(0xFFF4792A);
    const Color greyDot = Color(0xFFE0E0E0);

    return Container(
      width: 280,
      height: 220,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12), // Slightly reduced
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top-left clock icon in a white circle
          Container(
            width: 36,   // Reduced from 40
            height: 36,
            decoration: const BoxDecoration(
              color: iconCircleColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.clock,
              color: Colors.black,
              size: 16,   // Reduced from 18
            ),
          ),
          const SizedBox(height: 24), // Reduced from 30

          // "12 Days"
          const Text(
            '12 Days',
            style: TextStyle(
              fontSize: 20,    // Reduced from 24
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6), // Slightly reduced
          
          // Overdue Payments found!
          const Text(
            'Overdue Payments\nfound!',
            style: TextStyle(
              fontSize: 14,    // Reduced from 16
              color: Color(0xFF808080), // grey #808080
            ),
          ),
          const Spacer(),

          // Two rows of dots: total 20
          // For example: top row (8 orange, 2 grey), bottom row (2 orange, 8 grey).
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(10, (index) {
              final isOrange = index < 8; // first 8 are orange, then 2 grey
              return Container(
                width: 10,  // Reduced from 12
                height: 10,
                margin: const EdgeInsets.all(3), // Reduced from 4
                decoration: BoxDecoration(
                  color: isOrange ? orangeDot : greyDot,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(10, (index) {
              final isOrange = index < 2; // first 2 are orange, next 8 grey
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isOrange ? orangeDot : greyDot,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
