/// -----------------------------
/// ENUMS
/// -----------------------------

enum MoodType {
  happy,
  calm,
  anxious,
  sad,
  angry,
  tired,
}

enum EnergyLevel {
  low,
  medium,
  high,
}

/// -----------------------------
/// MOOD ENTRY MODEL
/// -----------------------------

class MoodEntry {
  final String id;
  final DateTime date;
  final MoodType mood;
  final EnergyLevel energy;
  final String? activityDone;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.energy,
    this.activityDone,
  });

  /// -----------------------------
  /// COPY
  /// -----------------------------

  MoodEntry copyWith({
    String? id,
    DateTime? date,
    MoodType? mood,
    EnergyLevel? energy,
    String? activityDone,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      activityDone: activityDone ?? this.activityDone,
    );
  }

  /// -----------------------------
  /// JSON SERIALIZATION
  /// -----------------------------

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'mood': mood.name,
        'energy': energy.name,
        'activityDone': activityDone,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mood: MoodType.values.byName(json['mood']),
      energy: EnergyLevel.values.byName(json['energy']),
      activityDone: json['activityDone'],
    );
  }
}

/// -----------------------------
/// REFLECTION ENTRY MODEL
/// -----------------------------

class ReflectionEntry {
  final String id;
  final DateTime date;
  final String text;

  ReflectionEntry({
    required this.id,
    required this.date,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'text': text,
      };

  factory ReflectionEntry.fromJson(Map<String, dynamic> json) {
    return ReflectionEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      text: json['text'],
    );
  }
}
