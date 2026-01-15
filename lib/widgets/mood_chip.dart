import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodChip extends StatelessWidget {
  final MoodType mood;
  final bool selected;
  final void Function(MoodType) onSelect;

  const MoodChip({
    super.key,
    required this.mood,
    required this.selected,
    required this.onSelect,
  });

  String _emoji() {
    switch (mood) {
      case MoodType.happy:
        return '😊';
      case MoodType.calm:
        return '🧘';
      case MoodType.anxious:
        return '😰';
      case MoodType.sad:
        return '😢';
      case MoodType.angry:
        return '😡';
      case MoodType.tired:
        return '😴';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0FDFA)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 1.5,
            color: selected
                ? const Color(0xFF14B8A6)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _emoji(),
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              mood.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
