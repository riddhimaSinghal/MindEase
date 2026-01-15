import 'dart:async';
import 'package:flutter/material.dart';

enum BreathPhase { inhale, hold1, exhale, hold2 }

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  int phaseIndex = 0;
  double progress = 0;
  int cycles = 0;

  final int maxCycles = 5;
  Timer? timer;

  final phases = [
    BreathPhase.inhale,
    BreathPhase.hold1,
    BreathPhase.exhale,
    BreathPhase.hold2,
  ];

  final durations = {
    BreathPhase.inhale: 3000,
    BreathPhase.hold1: 1500,
    BreathPhase.exhale: 3000,
    BreathPhase.hold2: 1500,
  };

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    const interval = 40;
    final duration = durations[phases[phaseIndex]]!;
    final step = 100 / (duration / interval);

    timer = Timer.periodic(const Duration(milliseconds: interval), (t) {
      setState(() {
        progress += step;
        if (progress >= 100) {
          progress = 0;
          phaseIndex++;
          if (phaseIndex >= phases.length) {
            phaseIndex = 0;
            cycles++;
            if (cycles >= maxCycles) {
              timer?.cancel();
            }
          }
        }
      });
    });
  }

  String _label() {
    switch (phases[phaseIndex]) {
      case BreathPhase.inhale:
        return 'Inhale...';
      case BreathPhase.exhale:
        return 'Exhale...';
      default:
        return 'Hold...';
    }
  }

  double _scale() {
    if (phases[phaseIndex] == BreathPhase.inhale) {
      return 1 + progress / 100 * 0.4;
    }
    if (phases[phaseIndex] == BreathPhase.exhale) {
      return 1.4 - progress / 100 * 0.4;
    }
    return 1.4;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Text(
            'Breath Focus',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            'Cycle ${cycles + 1} of $maxCycles',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),

          const SizedBox(height: 40),

          /// BREATHING CIRCLE
          Center(
            child: Transform.scale(
              scale: _scale(),
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF2DD4BF), Color(0xFF34D399)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _label(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          /// PROGRESS BAR
          Container(
            width: 240,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          /// STOP BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Stop Exercise',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
