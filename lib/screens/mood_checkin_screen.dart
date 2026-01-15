import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/mood.dart';
import '../widgets/mood_chip.dart';
import '../widgets/primary_button.dart';

class MoodCheckinScreen extends StatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  State<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  MoodType? selectedMood;
  EnergyLevel energy = EnergyLevel.medium;

  void _handleContinue() {
    if (selectedMood == null) return;

    context.read<AppProvider>().addMoodEntry(
          MoodEntry(
            id: '',
            date: DateTime.now(),
            mood: selectedMood!,
            energy: energy,
          ),
        );

    Navigator.pushNamed(
      context,
      '/support-choice',
      arguments: selectedMood,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppProvider>().state;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Text(
            'Hi ${state.name.isNotEmpty ? state.name : "there"}!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 32),

          /// MOOD SELECTION
          const Text(
            'CHOOSE YOUR MOOD',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MoodType.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              childAspectRatio: 4.5,
            ),
            itemBuilder: (context, index) {
              final mood = MoodType.values[index];
              return MoodChip(
                mood: mood,
                selected: selectedMood == mood,
                onSelect: (m) {
                  setState(() => selectedMood = m);
                },
              );
            },
          ),


          const SizedBox(height: 32),

          /// ENERGY LEVEL
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ENERGY LEVEL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: EnergyLevel.values.map((level) {
                    final bool isSelected = energy == level;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => energy = level);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ]
                                : null,
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFF2DD4BF),
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              level.name.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// CONTINUE BUTTON
          PrimaryButton(
            disabled: selectedMood == null,
            onPressed: _handleContinue,
            text: 'Continue',
          ),
        ],
      ),
    );
  }
}
