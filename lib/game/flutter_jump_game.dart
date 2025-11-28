import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/player_component.dart';
import 'managers/platform_manager.dart';
import 'platforms/platform_base.dart';

/// Main game class for Flutter-Jump
/// Manages game state, camera, world boundaries, and score tracking
class FlutterJumpGame extends FlameGame with HasCollisionDetection {
  late PlayerComponent player;
  late PlatformManager platformManager;
  
  // Game state
  bool isGameOver = false;
  int score = 0;
  double maxHeight = 0;
  
  // World boundaries
  double worldWidth = 400;
  double worldHeight = 800;
  
  // Callbacks for UI updates
  Function(int score)? onScoreUpdate;
  Function()? onGameOver;
  
  FlutterJumpGame({
    this.onScoreUpdate,
    this.onGameOver,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set camera to follow player with fixed viewport
    camera.viewfinder.anchor = Anchor.topLeft;
    
    // Initialize platform manager
    platformManager = PlatformManager(worldWidth: worldWidth);
    await add(platformManager);
    
    // Initialize player at the bottom center
    player = PlayerComponent(
      position: Vector2(worldWidth / 2, worldHeight - 200),
      worldWidth: worldWidth,
    );
    await add(player);
    
    // Generate initial platforms
    platformManager.generateInitialPlatforms(player.position.y);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (isGameOver) return;
    
    // Check for game over (player fell below screen)
    if (player.position.y > camera.viewfinder.position.y + worldHeight + 100) {
      _triggerGameOver();
      return;
    }
    
    // Update camera to follow player (world scrolls down)
    // Player stays in vertical center, world moves
    final targetCameraY = player.position.y - worldHeight * 0.4;
    if (targetCameraY < camera.viewfinder.position.y) {
      camera.viewfinder.position.y = targetCameraY;
      
      // Update score based on height climbed
      final heightClimbed = -targetCameraY;
      if (heightClimbed > maxHeight) {
        maxHeight = heightClimbed;
        score = (maxHeight / 10).toInt();
        onScoreUpdate?.call(score);
      }
    }
    
    // Generate new platforms as player climbs
    platformManager.updatePlatforms(camera.viewfinder.position.y);
    
    // Handle horizontal wrap-around (teleportation)
    if (player.position.x < -player.size.x / 2) {
      player.position.x = worldWidth + player.size.x / 2;
    } else if (player.position.x > worldWidth + player.size.x / 2) {
      player.position.x = -player.size.x / 2;
    }
  }
  
  /// Trigger game over state
  void _triggerGameOver() {
    if (isGameOver) return;
    isGameOver = true;
    onGameOver?.call();
  }
  
  /// Reset game to initial state
  void resetGame() {
    isGameOver = false;
    score = 0;
    maxHeight = 0;
    
    // Reset camera
    camera.viewfinder.position = Vector2.zero();
    
    // Remove all existing platforms
    platformManager.clearPlatforms();
    
    // Reset player position
    player.reset(Vector2(worldWidth / 2, worldHeight - 200));
    
    // Generate new initial platforms
    platformManager.generateInitialPlatforms(player.position.y);
  }
  
  /// Move player left
  void moveLeft() {
    player.moveLeft();
  }
  
  /// Move player right  
  void moveRight() {
    player.moveRight();
  }
  
  /// Stop player horizontal movement
  void stopMovement() {
    player.stopHorizontalMovement();
  }
  
  /// Set player horizontal movement from tilt (-1.0 to 1.0)
  void setTiltMovement(double tiltValue) {
    player.setTiltMovement(tiltValue);
  }
  
  /// Check collision with platforms
  void checkPlatformCollision(PlatformBase platform) {
    if (isGameOver) return;
    
    // Only trigger jump if player is falling
    if (player.velocity.y > 0) {
      // Check if player's bottom is hitting platform's top
      final playerBottom = player.position.y + player.size.y / 2;
      final platformTop = platform.position.y - platform.size.y / 2;
      
      if ((playerBottom >= platformTop - 5) && (playerBottom <= platformTop + 10)) {
        final playerLeft = player.position.x - player.size.x / 2;
        final playerRight = player.position.x + player.size.x / 2;
        final platformLeft = platform.position.x - platform.size.x / 2;
        final platformRight = platform.position.x + platform.size.x / 2;
        
        // Check horizontal overlap
        if (playerRight > platformLeft && playerLeft < platformRight) {
          player.jump(platform.jumpBoost);
          platform.onPlayerLand();
        }
      }
    }
  }
  
  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue background
}
