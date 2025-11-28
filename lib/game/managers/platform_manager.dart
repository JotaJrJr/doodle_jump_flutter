import 'dart:math';
import 'package:flame/components.dart';
import '../flutter_jump_game.dart';
import '../platforms/platform_base.dart';
import '../platforms/normal_platform.dart';
import '../platforms/boost_platform.dart';

/// Manages procedural platform generation and lifecycle
class PlatformManager extends Component with HasGameReference<FlutterJumpGame> {
  final double worldWidth;
  final List<PlatformBase> _platforms = [];
  final Random _random = Random();
  
  // Platform generation settings
  final double _verticalSpacing = 120; // Vertical distance between platforms
  final double _platformSpawnAhead = 1000; // How far ahead to generate platforms
  double _lastPlatformY = 0;
  
  // Boost platform probability (10%)
  final double _boostPlatformChance = 0.1;
  
  PlatformManager({required this.worldWidth});
  
  /// Generate initial platforms for game start
  void generateInitialPlatforms(double playerStartY) {
    _lastPlatformY = playerStartY;
    
    // Generate platforms from player position upward
    for (int i = 0; i < 15; i++) {
      _spawnPlatform(_lastPlatformY - (i * _verticalSpacing));
    }
  }
  
  /// Update platforms based on camera position
  void updatePlatforms(double cameraY) {
    // Remove platforms that are below the camera view
    _platforms.removeWhere((platform) {
      if (platform.position.y > cameraY + gameRef.worldHeight + 100) {
        platform.removeFromParent();
        return true;
      }
      return false;
    });
    
    // Generate new platforms ahead of the camera
    while (_lastPlatformY > cameraY - _platformSpawnAhead) {
      _lastPlatformY -= _verticalSpacing;
      _spawnPlatform(_lastPlatformY);
    }
  }
  
  /// Spawn a single platform at specified Y position
  void _spawnPlatform(double yPosition) {
    // Random X position with margins
    final margin = 50.0;
    final xPosition = margin + _random.nextDouble() * (worldWidth - margin * 2);
    
    // Determine platform type (10% boost, 90% normal)
    final PlatformBase platform;
    if (_random.nextDouble() < _boostPlatformChance) {
      platform = BoostPlatform(position: Vector2(xPosition, yPosition));
    } else {
      platform = NormalPlatform(position: Vector2(xPosition, yPosition));
    }
    
    _platforms.add(platform);
    gameRef.add(platform);
  }
  
  /// Clear all platforms
  void clearPlatforms() {
    for (final platform in _platforms) {
      platform.removeFromParent();
    }
    _platforms.clear();
    _lastPlatformY = 0;
  }
  
  /// Get all active platforms
  List<PlatformBase> get platforms => _platforms;
}
