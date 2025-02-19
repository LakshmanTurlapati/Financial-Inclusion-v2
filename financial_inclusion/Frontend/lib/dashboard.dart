import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/grid.dart';
import 'widgets/gauge.dart';
import 'widgets/cash_flow.dart';
import 'widgets/linker.dart';
import 'widgets/line_chart.dart';
import 'widgets/bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isHamburgerHovered = false;
  bool _isSearchHovered = false;
  bool _isPlusHovered = false;
  bool _isBookHovered = false;

  @override
  Widget build(BuildContext context) {
    final String day = DateFormat('d').format(DateTime.now());
    final String weekday = DateFormat('E').format(DateTime.now());
    final String month = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFFEDEDED),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Row(
                      children: [
                        // Hamburger Menu with Animated Border
                        MouseRegion(
                          onEnter: (_) => setState(() => _isHamburgerHovered = true),
                          onExit: (_) => setState(() => _isHamburgerHovered = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isHamburgerHovered 
                                  ? Colors.grey[200] 
                                  : Colors.white,
                              border: _isHamburgerHovered
                                  ? Border.all(color: const Color(0xFF808080), width: 1.0)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 18,
                                  height: 2,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 6),
                                Transform.translate(
                                  offset: const Offset(4, 0),
                                  child: Container(
                                    width: 18,
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 18,
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Logo
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'FI_light.png',
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title
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

                        // Plus Button with Animated Border
                        GestureDetector(
                          onTap: () {},
                          child: MouseRegion(
                            onEnter: (_) => setState(() => _isPlusHovered = true),
                            onExit: (_) => setState(() => _isPlusHovered = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isPlusHovered
                                    ? Colors.grey[300]
                                    : const Color(0xFFEDEDED),
                                border: Border.all(
                                  color: _isPlusHovered 
                                      ? Colors.black 
                                      : const Color(0xFF808080),
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
                        ),
                        const SizedBox(width: 12),

                        // Profile
                        Row(
                          children: [
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

                        // Search Button with Animated Border
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              MouseRegion(
                                onEnter: (_) => setState(() => _isSearchHovered = true),
                                onExit: (_) => setState(() => _isSearchHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isSearchHovered
                                        ? Colors.grey[300]
                                        : const Color(0xFFEDEDED),
                                    border: Border.all(
                                      color: _isSearchHovered
                                          ? Colors.black
                                          : const Color(0xFF808080),
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

                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Row(
                      children: [
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
                                day,
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
                        const Text(
                          '|',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {},
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

                        // Help Section with Animated Book Button
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
                              onTap: () {},
                              child: MouseRegion(
                                onEnter: (_) => setState(() => _isBookHovered = true),
                                onExit: (_) => setState(() => _isBookHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isBookHovered
                                        ? Colors.grey[200]
                                        : Colors.white,
                                    border: _isBookHovered
                                        ? Border.all(color: Colors.black, width: 1.0)
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: const FaIcon(
                                    FontAwesomeIcons.book,
                                    color: Color(0xFF808080),
                                    size: 24,
                                  ),
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
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 420,
                          child: LinkerWidget(),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 420,
                          child: CashFlowWidget(ssn: "143-38-3618"),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 420,
                          child: ScoreGauge(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 200,
                          child: OverdueGridWidget(),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 420,
                          child: Transform.translate(
                            offset: const Offset(0, -16),
                            child: LineChartWidget(),
                          ),
                        ),
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