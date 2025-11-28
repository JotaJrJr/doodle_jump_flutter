import 'package:flutter/foundation.dart';
import '../services/leaderboard_service.dart';

/// ViewModel for the leaderboard screen
/// Loads and formats leaderboard data
class LeaderboardViewModel extends ChangeNotifier {
  final LeaderboardService _leaderboardService;
  
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = false;
  
  LeaderboardViewModel({
    LeaderboardService? leaderboardService,
  }) : _leaderboardService = leaderboardService ?? LeaderboardService();
  
  // Getters
  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  bool get hasEntries => _entries.isNotEmpty;
  
  /// Load leaderboard data
  Future<void> loadLeaderboard() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _entries = await _leaderboardService.getLeaderboard();
    } catch (e) {
      print('Error loading leaderboard: $e');
      _entries = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Clear all leaderboard data
  Future<void> clearLeaderboard() async {
    await _leaderboardService.clearLeaderboard();
    _entries = [];
    notifyListeners();
  }
  
  /// Format date string for display
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
