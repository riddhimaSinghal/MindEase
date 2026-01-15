import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/mood.dart';

class SupportChoiceScreen extends StatelessWidget {
  const SupportChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final state = app.state;

    final MoodType? lastMood =
        ModalRoute.of(context)?.settings.arguments as MoodType? ??
            (state.moodEntries.isNotEmpty
                ? state.moodEntries.first.mood
                : null);

    final String moodText =
        lastMood != null ? lastMood.name : 'your feelings';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Text(
            'Hi ${state.name.isNotEmpty ? state.name : "there"} 👋',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
              children: [
                const TextSpan(text: 'You’re feeling '),
                TextSpan(
                  text: moodText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D9488),
                  ),
                ),
                const TextSpan(text: '. How can we support you?'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// CHOICES
          ChoiceCard(
            icon: '✨',
            title: 'Comfort Me',
            desc: 'Gentle validation and kind words.',
            color: const Color(0xFFFFF1F2),
            onTap: () {
              Navigator.pushNamed(context, '/comfort');
            },
          ),
          const SizedBox(height: 16),
          ChoiceCard(
            icon: '🌬️',
            title: 'Guided Breathing',
            desc: 'A calming breathing exercise.',
            color: const Color(0xFFEFF6FF),
            onTap: () {
              Navigator.pushNamed(context, '/breathing');
            },
          ),
          const SizedBox(height: 16),
          ChoiceCard(
            icon: '✍️',
            title: 'Reflect & Journal',
            desc: 'Write down your thoughts.',
            color: const Color(0xFFFFFBEB),
            onTap: () {
              Navigator.pushNamed(context, '/reflection');
            },
          ),

          const SizedBox(height: 24),

          /// CHANGE MOOD
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/mood-checkin');
            },
            child: const Text(
              'Change my mood',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final Color color;
  final VoidCallback onTap;

  const ChoiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
