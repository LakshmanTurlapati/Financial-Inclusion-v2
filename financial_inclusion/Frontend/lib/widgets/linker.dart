import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkerWidget extends StatefulWidget {
  const LinkerWidget({Key? key}) : super(key: key);

  @override
  _LinkerWidgetState createState() => _LinkerWidgetState();
}

class _LinkerWidgetState extends State<LinkerWidget> {
  bool _isHoveringSwitch = false;
  bool _isHoveringDetails = false;
  bool _isHoveringLink = false;
  bool _isHoveringEdit = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ────────── TOP (WHITE) SECTION ──────────
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT SIDE: logo + text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Only the LOGO is shifted left
                      Transform.translate(
                        offset: const Offset(-68, 0),
                        child: SizedBox(
                          height: 30,
                          child: SvgPicture.asset(
                            'assets/capitalone.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Some vertical spacing
                      const SizedBox(height: 8),

                      // Everything under the logo gets left padding
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Linked to Checking Account',
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '**** 2719',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Row of 2 hoverable buttons
                            Row(
                              children: [
                                // DETAILS (black) button
                                MouseRegion(
                                  onEnter: (_) => setState(() => _isHoveringDetails = true),
                                  onExit: (_) => setState(() => _isHoveringDetails = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isHoveringDetails ? Colors.black87 : Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Details',
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // LINK (light grey) button
                                MouseRegion(
                                  onEnter: (_) => setState(() => _isHoveringLink = true),
                                  onExit: (_) => setState(() => _isHoveringLink = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isHoveringLink
                                          ? const Color(0xFFE0E0E0)
                                          : const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Link',
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                      ),
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
                ),

                // RIGHT SIDE: hoverable "Switch" button
                MouseRegion(
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
                          'Switch',
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
              ],
            ),
          ),

          // ────────── BOTTOM (GREY) SECTION ──────────
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Hoverable "Edit Accounts" button
                MouseRegion(
                  onEnter: (_) => setState(() => _isHoveringEdit = true),
                  onExit: (_) => setState(() => _isHoveringEdit = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isHoveringEdit
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
                          child: const Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Edit Accounts',
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
          ),
        ],
      ),
    );
  }
}
