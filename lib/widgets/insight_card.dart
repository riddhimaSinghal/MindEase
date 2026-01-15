import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final Color color;

  const InsightCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color = const Color(0xFF0D9488), // teal-600
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// MAIN CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          /// ICON BACKGROUND
          Positioned(
            right: -12,
            bottom: -12,
            child: IgnorePointer(
              child: Text(
                icon,
                style: const TextStyle(
                  fontSize: 96,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
