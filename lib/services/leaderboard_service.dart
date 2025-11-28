import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model class representing a single leaderboard entry
class LeaderboardEntry {
  final String date;
  final int score;
  final double maxDistance;

  LeaderboardEntry({
    required this.date,
    required this.score,
    required this.maxDistance,
  });

  /// Convert entry to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'score': score,
      'maxDistance': maxDistance,
    };
  }

  /// Create entry from JSON
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      date: json['date'] as String,
      score: json['score'] as int,
      maxDistance: (json['maxDistance'] as num).toDouble(),
    );
  }
}

/// Service for managing local leaderboard data
class LeaderboardService {
  static const String _storageKey = 'flutter_jump_leaderboard';
  static const int _maxEntries = 10;

  /// Save a new game score to the leaderboard
  Future<void> saveScore({
    required int score,
    required double maxDistance,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing entries
      final entries = await getLeaderboard();
      
      // Create new entry with current timestamp
      final newEntry = LeaderboardEntry(
        date: DateTime.now().toString().substring(0, 19), // Format: "2025-01-01 14:22:53"
        score: score,
        maxDistance: maxDistance,
      );
      
      // Add new entry at the beginning (most recent first)
      entries.insert(0, newEntry);
      
      // Keep only the last 10 entries
      if (entries.length > _maxEntries) {
        entries.removeRange(_maxEntries, entries.length);
      }
      
      // Convert to JSON and save
      final jsonList = entries.map((e) => e.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving score to leaderboard: $e');
    }
  }

  /// Retrieve all leaderboard entries (latest first)
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => LeaderboardEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading leaderboard: $e');
      return [];
    }
  }

  /// Clear all leaderboard data
  Future<void> clearLeaderboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing leaderboard: $e');
    }
  }
}
