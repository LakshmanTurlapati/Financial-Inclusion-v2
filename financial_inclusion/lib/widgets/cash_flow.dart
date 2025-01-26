import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CashFlowWidget extends StatefulWidget {
  final String ssn;
  const CashFlowWidget({Key? key, required this.ssn}) : super(key: key);

  @override
  _CashFlowWidgetState createState() => _CashFlowWidgetState();
}

class _CashFlowWidgetState extends State<CashFlowWidget> {
  double totalIncome = 0.0;
  double totalExpenditure = 0.0;

  bool _isHoveringSwitch = false;
  bool _isHoveringViewChart = false;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/temp.json');
      final List<dynamic> data = json.decode(jsonString);

      final userData = data.where((item) => item['SSN'] == widget.ssn);

      double incomeSum = 0.0;
      double expenditureSum = 0.0;

      for (final item in userData) {
        incomeSum += (item['Annual_Income'] as num?)?.toDouble() ?? 0.0;
        expenditureSum += (item['Rent_Expenditure'] as num?)?.toDouble() ?? 0.0;
        expenditureSum += (item['Utilities_Expenditure'] as num?)?.toDouble() ?? 0.0;
        expenditureSum += (item['Education_Expenditure'] as num?)?.toDouble() ?? 0.0;
        expenditureSum += (item['Healthcare_Expenditure'] as num?)?.toDouble() ?? 0.0;
        expenditureSum += (item['Luxury_Expenditure'] as num?)?.toDouble() ?? 0.0;
        expenditureSum += (item['Travel_Expenditure'] as num?)?.toDouble() ?? 0.0;
      }

      setState(() {
        totalIncome = incomeSum;
        totalExpenditure = expenditureSum;
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Grey outer container
      margin: const EdgeInsets.all(16),
      // Uniform minHeight among all widgets
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------ TOP (WHITE) SECTION ------------
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Left side: arrow circle + "Total Income"
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Arrow in grey circle
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDEDED),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_downward, size: 20, color: Colors.black),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Total Income',
                            style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '\$',
                            style: TextStyle(
                              color: Color(0xFFF4792A),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' ${totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right side: Switch button (hoverable)
                Positioned(
                  top: 0,
                  right: 0,
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringSwitch = true),
                    onExit: (_) => setState(() => _isHoveringSwitch = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isHoveringSwitch ? Colors.grey.shade200 : Colors.white,
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
                          Icon(Icons.arrow_drop_down, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ------------ BOTTOM (GREY) SECTION ------------
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with arrow + "Total Expenditure"
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_upward, size: 20, color: Colors.black),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Total Expenditure',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Row with $ in orange, the numeric, and the "View Chart" on the right
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$',
                          style: TextStyle(
                            color: Color(0xFFF4792A),
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' ${totalExpenditure.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHoveringViewChart = true),
                      onExit: (_) => setState(() => _isHoveringViewChart = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isHoveringViewChart
                              ? const Color(0xFFF4792A).withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF4792A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bar_chart, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'View Chart',
                              style: TextStyle(
                                color: Color(0xFFF4792A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}