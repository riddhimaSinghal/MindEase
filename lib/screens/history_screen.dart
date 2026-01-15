import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/mood.dart';
import '../widgets/insight_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final state = app.state;

    final recentMoods = state.moodEntries.take(10).toList();
    final recentReflections = state.reflectionEntries.take(5).toList();

    final insight = _getInsight(state);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          const Text(
            'Your Journey',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Progress you can be proud of.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 24),

          /// INSIGHT CARD
          InsightCard(
            title: insight.title,
            description: insight.desc,
            icon: insight.icon,
            color: insight.color,
          ),

          const SizedBox(height: 32),

          /// RECENT MOODS
          const Text(
            'RECENT MOODS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),

          if (recentMoods.isEmpty)
            _emptyState(icon: '📊', text: 'No history yet.')
          else
            Column(
              children: recentMoods.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            _getMoodEmoji(entry.mood),
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.mood.name.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_formatDate(entry.date)} • ${entry.energy.name} Energy',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2DD4BF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 32),

          /// RECENT REFLECTIONS
          const Text(
            'RECENT REFLECTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),

          if (recentReflections.isEmpty)
            _emptyState(icon: '✍️', text: 'No journals yet.')
          else
            Column(
              children: recentReflections.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(entry.createdAt),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"${entry.text}"',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF334155),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

/// -----------------------------
/// HELPERS
/// -----------------------------

InsightData _getInsight(AppState state) {
  if (state.moodEntries.isEmpty) {
    return InsightData(
      title: 'Welcome',
      desc: 'Start checking in to see patterns in your emotional health!',
      icon: '🌱',
      color: const Color(0xFF4F46E5),
    );
  }

  final lastThree = state.moodEntries.take(3).toList();
  final anxiousCount =
      state.moodEntries.where((e) => e.mood == MoodType.anxious).length;

  if (anxiousCount >= 2) {
    return InsightData(
      title: 'Anxiety Pattern',
      desc:
          'You\'ve been feeling anxious lately. Consider setting aside 5 minutes for breathing today.',
      icon: '🌬️',
      color: const Color(0xFF2563EB),
    );
  }

  if (lastThree.every((m) => m.mood == MoodType.happy)) {
    return InsightData(
      title: 'Positive Streak',
      desc:
          'You\'re on a roll! Take a moment to note what\'s bringing you this joy.',
      icon: '✨',
      color: const Color(0xFF0D9488),
    );
  }

  if (lastThree.any((m) => m.mood == MoodType.tired)) {
    return InsightData(
      title: 'Rest Needed',
      desc:
          'Energy seems low. Small rests throughout the day could help recharge you.',
      icon: '😴',
      color: const Color(0xFFD97706),
    );
  }

  return InsightData(
    title: 'Keep Growing',
    desc:
        'Consistent tracking helps build emotional intelligence. Great job staying mindful!',
    icon: '📊',
    color: const Color(0xFF0D9488),
  );
}

String _getMoodEmoji(MoodType mood) {
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

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

Widget _emptyState({required String icon, required String text}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 40),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(32),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
      ],
    ),
  );
}

/// -----------------------------
/// INSIGHT DATA MODEL
/// -----------------------------

class InsightData {
  final String title;
  final String desc;
  final String icon;
  final Color color;

  InsightData({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
  });
}
