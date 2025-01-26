import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/grid.dart';
import 'widgets/gauge.dart';
import 'widgets/cash_flow.dart';
import 'widgets/linker.dart';
import 'widgets/line_chart.dart'; 
import 'widgets/bar.dart'; 


class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get today's date
    final String day = DateFormat('d').format(DateTime.now());      // Day number
    final String weekday = DateFormat('E').format(DateTime.now()); // Short weekday name
    final String month = DateFormat('MMMM').format(DateTime.now()); // Full month name

    return Scaffold(
      body: Column(
        children: [
          // ───────────────── TOP AREA (HEADER/TOOLBAR) ─────────────────
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFFEDEDED),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Top Row: Hamburger, Logo, Title, Profile, Search ───
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Row(
                      children: [
                        // Hamburger menu icon inside a white circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Top line
                              Container(
                                width: 18,
                                height: 2,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 6),
                              // Middle line (shifted right)
                              Transform.translate(
                                offset: const Offset(4, 0),
                                child: Container(
                                  width: 18,
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Bottom line
                              Container(
                                width: 18,
                                height: 2,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Logo inside a black circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,
                          // Replace 'FI_light.png' with your actual asset path:
                          child: Image.asset(
                            'FI_light.png',
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title + subtitle
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Financial Inclusion',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Plus icon (Add)
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement add action
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFEDEDED),
                              border: Border.all(
                                color: const Color(0xFF808080),
                                width: 1.0,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // User profile (avatar + text)
                        Row(
                          children: [
                            // Profile icon background
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF4792A),
                              ),
                              alignment: Alignment.center,
                              child: const FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Name + ID
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Lakshman',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'ID: VXT230021',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 80),

                        // Search
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement search
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFEDEDED),
                                  border: Border.all(
                                    color: const Color(0xFF808080),
                                    width: 1.0,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const FaIcon(
                                  FontAwesomeIcons.search,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Search Anything..',
                                style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ─── Bottom row in header: Date + "Optimize" + Help section ───
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Row(
                      children: [
                        // Circle w/ day + text of weekday, month
                        Row(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFEDEDED),
                                border: Border.all(
                                  color: const Color(0xFF808080),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                day, // day number
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$weekday,'),
                                Text(month),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Separator
                        const Text(
                          '|',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Orange "Optimize Pre-cursor" button
                        ElevatedButton(
                          onPressed: () {
                            // TODO: "Optimize Pre-cursor" action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4792A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: Row(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: 'Optimise ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Pre-cursor',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // "Hey, Need help?" + doc icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Hey, Need help?👋',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'You can find everything here!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 50),
                            GestureDetector(
                              onTap: () {
                                // TODO: Implement documentation
                              },
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: const FaIcon(
                                  FontAwesomeIcons.book,
                                  color: Color(0xFF808080),
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 38),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ), // End of top Expanded

          // ───────────────── BOTTOM AREA (MAIN CONTENT) ─────────────────
Expanded(
  flex: 3,
  child: Container(
    color: Colors.white,
    width: double.infinity,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Row 1: Linker + CashFlow + ScoreGauge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed-width LinkerWidget
              SizedBox(
                width: 420,
                child: LinkerWidget(),
              ),
              const SizedBox(width: 20),

              // Fixed-width CashFlowWidget
              SizedBox(
                width: 420,
                child: CashFlowWidget(ssn: "143-38-3618"),
              ),
              const SizedBox(width: 20),

              // Fixed-width ScoreGauge (or any approximate size)
              SizedBox(
                width: 420,
                child: ScoreGauge(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Row 2: LineChart ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed-width LineChartWidget
                            const SizedBox(width: 20),

              SizedBox(
  width: 200,
   // Move up by 20 pixels
    child: OverdueGridWidget(),
  
),
              const SizedBox(width: 20),
              SizedBox(
                width: 420,
                child: Transform.translate(offset: Offset(0, -16),
             
                child:LineChartWidget() ,),
              ),const SizedBox(width: 20),
              // SizedBox(
              //   width: 420,
              //   child: AvgIncomeChartWidget(),
              // )
              

            ],
          ),
        ],
      ),
    ),
  ),
)
        ],
      ),
    );
  }
}
