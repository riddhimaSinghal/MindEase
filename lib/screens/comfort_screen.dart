import 'dart:math';
import 'package:flutter/material.dart';

enum ShapeColor { sage, blush, ocean }

class ComfortScreen extends StatefulWidget {
  const ComfortScreen({super.key});

  @override
  State<ComfortScreen> createState() => _ComfortScreenState();
}

class _ComfortScreenState extends State<ComfortScreen> {
  final List<String> groundingSteps = [
    "Identify 5 things you can see.",
    "Identify 4 things you can touch.",
    "Identify 3 things you can hear.",
    "Identify 2 things you can smell.",
    "Identify 1 thing you can taste.",
  ];

  final List<ShapeColor> colors = [
    ShapeColor.sage,
    ShapeColor.blush,
    ShapeColor.ocean,
  ];

  int step = 0;
  ShapeColor shapeColor = ShapeColor.sage;
  final Random _random = Random();

  void nextStep() {
    if (step < groundingSteps.length - 1) {
      setState(() => step++);
    }
  }

  void resetGrounding() {
    setState(() => step = 0);
  }

  void onDrop(ShapeColor binColor) {
    if (binColor == shapeColor) {
      Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          shapeColor = colors[_random.nextInt(colors.length)];
        });
      });
    }
  }

  Color _shapeBg() {
    switch (shapeColor) {
      case ShapeColor.sage:
        return const Color(0xFF2DD4BF);
      case ShapeColor.blush:
        return const Color(0xFFF9A8D4);
      case ShapeColor.ocean:
        return const Color(0xFF38BDF8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          /// ================= GROUNDING CARD =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GROUNDING',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  groundingSteps[step],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 24),

                /// Progress dots
                Row(
                  children: List.generate(
                    groundingSteps.length,
                    (i) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= step
                            ? const Color(0xFF14B8A6)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Buttons
                Column(
                  children: [
                    if (step < groundingSteps.length - 1)
                      OutlinedButton(
                        onPressed: nextStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          side: const BorderSide(color: Color(0xFF99F6E4)),
                        ),
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: resetGrounding,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        side:
                            const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      child: const Text(
                        'RESET',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ================= SOFT SORT CARD =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SOFT SORT',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                /// Drop bins
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ShapeColor.values.map((color) {
                    return DragTarget<ShapeColor>(
                      onWillAccept: (_) => true,
                      onAccept: (data) => onDrop(color),
                      builder: (_, __, ___) {
                        return Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFE2E8F0)),
                            color: color == ShapeColor.sage
                                ? const Color(0xFFCCFBF1)
                                : color == ShapeColor.blush
                                    ? const Color(0xFFFCE7F3)
                                    : const Color(0xFFE0F2FE),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                /// Draggable shape
                Center(
                  child: Draggable<ShapeColor>(
                    data: shapeColor,
                    feedback: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _shapeBg(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    childWhenDragging: const SizedBox(
                      width: 48,
                      height: 48,
                    ),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _shapeBg(),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
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
