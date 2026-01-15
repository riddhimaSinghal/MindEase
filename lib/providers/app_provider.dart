import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mood.dart';

/// -----------------------------
/// MODELS
/// -----------------------------

class ReflectionEntry {
  final String id;
  final String text;
  final DateTime createdAt;

  ReflectionEntry({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReflectionEntry.fromJson(Map<String, dynamic> json) {
    return ReflectionEntry(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// -----------------------------
/// APP STATE
/// -----------------------------

class AppState {
  bool hasOnboarded;
  bool isAuthenticated;
  bool hasCheckedInToday;
  String name;
  String email;
  List<MoodEntry> moodEntries;
  List<ReflectionEntry> reflectionEntries;

  AppState({
    required this.hasOnboarded,
    required this.isAuthenticated,
    required this.hasCheckedInToday,
    required this.name,
    required this.email,
    required this.moodEntries,
    required this.reflectionEntries,
  });

  factory AppState.initial() {
    return AppState(
      hasOnboarded: false,
      isAuthenticated: false,
      hasCheckedInToday: false,
      name: '',
      email: '',
      moodEntries: [],
      reflectionEntries: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'hasOnboarded': hasOnboarded,
        'isAuthenticated': isAuthenticated,
        'hasCheckedInToday': hasCheckedInToday,
        'name': name,
        'email': email,
        'moodEntries': moodEntries.map((e) => e.toJson()).toList(),
        'reflectionEntries':
            reflectionEntries.map((e) => e.toJson()).toList(),
      };

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      hasOnboarded: json['hasOnboarded'],
      isAuthenticated: json['isAuthenticated'],
      hasCheckedInToday: json['hasCheckedInToday'],
      name: json['name'],
      email: json['email'],
      moodEntries: (json['moodEntries'] as List)
          .map((e) => MoodEntry.fromJson(e))
          .toList(),
      reflectionEntries: (json['reflectionEntries'] as List)
          .map((e) => ReflectionEntry.fromJson(e))
          .toList(),
    );
  }
}

/// -----------------------------
/// PROVIDER
/// -----------------------------

class AppProvider extends ChangeNotifier {
  static const String _storageKey = 'mindease_data';

  AppState _state = AppState.initial();
  AppState get state => _state;

  AppProvider() {
    _loadFromStorage();
  }

  /// -----------------------------
  /// STORAGE
  /// -----------------------------

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);

    if (saved != null) {
      _state = AppState.fromJson(jsonDecode(saved));
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_state.toJson()));
  }

  /// -----------------------------
  /// AUTH
  /// -----------------------------

  void login(String name, String email) {
    _state.isAuthenticated = true;
    _state.name = name;
    _state.email = email;
    _saveAndNotify();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    _state = AppState.initial();
    notifyListeners();
  }

  void setOnboarded() {
    _state.hasOnboarded = true;
    _saveAndNotify();
  }

  /// -----------------------------
  /// MOOD
  /// -----------------------------

  void addMoodEntry(MoodEntry entry) {
    _state.moodEntries = [
      entry.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      ..._state.moodEntries,
    ].take(50).toList();

    _saveAndNotify();
  }

  /// -----------------------------
  /// REFLECTION
  /// -----------------------------

  void addReflectionEntry(String text) {
    final entry = ReflectionEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );

    _state.reflectionEntries = [
      entry,
      ..._state.reflectionEntries,
    ].take(50).toList();

    _saveAndNotify();
  }

  /// -----------------------------
  /// CLEAR DATA
  /// -----------------------------

  void clearAllData() {
    logout();
  }

  /// -----------------------------
  /// HELPERS
  /// -----------------------------

  void _saveAndNotify() {
    _saveToStorage();
    notifyListeners();
  }
}
