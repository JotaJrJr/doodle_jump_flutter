import 'package:flutter/foundation.dart';
import '../services/leaderboard_service.dart';
import '../services/sensor_service.dart';

/// ViewModel for the game screen
/// Manages game state, score updates, and sensor/leaderboard integration
class GameViewModel extends ChangeNotifier {
  final LeaderboardService _leaderboardService;
  final SensorService _sensorService;
  
  // Game state
  bool _isPlaying = false;
  bool _isGameOver = false;
  int _currentScore = 0;
  double _maxDistance = 0;
  bool _sensorAvailable = false;
  bool _useSensor = false;
  
  GameViewModel({
    LeaderboardService? leaderboardService,
    SensorService? sensorService,
  })  : _leaderboardService = leaderboardService ?? LeaderboardService(),
        _sensorService = sensorService ?? SensorService() {
    _checkSensorAvailability();
  }
  
  // Getters
  bool get isPlaying => _isPlaying;
  bool get isGameOver => _isGameOver;
  int get currentScore => _currentScore;
  double get maxDistance => _maxDistance;
  bool get sensorAvailable => _sensorAvailable;
  bool get useSensor => _useSensor;
  SensorService get sensorService => _sensorService;
  
  /// Check if gyroscope sensor is available
  Future<void> _checkSensorAvailability() async {
    _sensorAvailable = await _sensorService.isSensorAvailable();
    notifyListeners();
  }
  
  /// Start a new game
  void startGame() {
    _isPlaying = true;
    _isGameOver = false;
    _currentScore = 0;
    _maxDistance = 0;
    
    // Start sensor if enabled
    if (_useSensor && _sensorAvailable) {
      _sensorService.startListening();
    }
    
    notifyListeners();
  }
  
  /// Update current score
  void updateScore(int score) {
    _currentScore = score;
    _maxDistance = score * 10.0; // Convert score back to distance
    notifyListeners();
  }
  
  /// Handle game over
  Future<void> gameOver() async {
    _isGameOver = true;
    _isPlaying = false;
    
    // Stop sensor
    _sensorService.stopListening();
    
    // Save score to leaderboard
    await _leaderboardService.saveScore(
      score: _currentScore,
      maxDistance: _maxDistance,
    );
    
    notifyListeners();
  }
  
  /// Toggle sensor usage
  void toggleSensor() {
    _useSensor = !_useSensor;
    
    if (_useSensor && _isPlaying) {
      _sensorService.startListening();
    } else {
      _sensorService.stopListening();
    }
    
    notifyListeners();
  }
  
  /// Pause game
  void pauseGame() {
    _isPlaying = false;
    _sensorService.stopListening();
    notifyListeners();
  }
  
  /// Resume game
  void resumeGame() {
    _isPlaying = true;
    if (_useSensor && _sensorAvailable) {
      _sensorService.startListening();
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }
}
