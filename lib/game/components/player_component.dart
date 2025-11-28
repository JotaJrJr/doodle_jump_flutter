import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flutter_jump_game.dart';

/// Player component using FlutterLogo as visual representation
/// Handles physics (gravity, velocity), collision detection, and movement
class PlayerComponent extends PositionComponent with HasGameReference<FlutterJumpGame> {
  // Physics properties
  Vector2 velocity = Vector2.zero();
  final double gravity = 1200; // Gravity acceleration
  final double horizontalSpeed = 300; // Horizontal movement speed
  
  // Movement state
  double _horizontalInput = 0; // -1 = left, 1 = right, 0 = no input
  double _tiltInput = 0; // Tilt from gyroscope
  
  final double worldWidth;
  
  PlayerComponent({
    required Vector2 position,
    required this.worldWidth,
  }) : super(
         position: position,
         size: Vector2(40, 40),
         anchor: Anchor.center,
       );
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameRef.isGameOver) return;
    
    // Apply gravity
    velocity.y += gravity * dt;
    
    // Apply horizontal movement (button input or tilt)
    final totalHorizontalInput = _horizontalInput + _tiltInput;
    velocity.x = totalHorizontalInput.clamp(-1.0, 1.0) * horizontalSpeed;
    
    // Update position
    position += velocity * dt;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw FlutterLogo
    // Create a simple Flutter logo representation
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw a simple Flutter-inspired design
    // Upper triangle (light blue)
    paint.color = const Color(0xFF02569B);
    final path1 = Path()
      ..moveTo(-15, -15)
      ..lineTo(15, -15)
      ..lineTo(15, 15)
      ..close();
    canvas.drawPath(path1, paint);
    
    // Lower triangle (darker blue)
    paint.color = const Color(0xFF0175C2);
    final path2 = Path()
      ..moveTo(-15, 15)
      ..lineTo(15, 15)
      ..lineTo(-15, -15)
      ..close();
    canvas.drawPath(path2, paint);
    
    // Center square (cyan accent)
    paint.color = const Color(0xFF13B9FD);
    canvas.drawRect(
      const Rect.fromLTWH(-5, -5, 10, 10),
      paint,
    );
  }
  
  /// Make the player jump with specified boost force
  void jump(double boost) {
    velocity.y = -boost;
  }
  
  /// Move player left (button press)
  void moveLeft() {
    _horizontalInput = -1;
  }
  
  /// Move player right (button press)
  void moveRight() {
    _horizontalInput = 1;
  }
  
  /// Stop horizontal movement from buttons
  void stopHorizontalMovement() {
    _horizontalInput = 0;
  }
  
  /// Set movement from tilt sensor (-1.0 to 1.0)
  void setTiltMovement(double tiltValue) {
    _tiltInput = tiltValue;
  }
  
  /// Reset player to initial state
  void reset(Vector2 newPosition) {
    position = newPosition.clone();
    velocity = Vector2.zero();
    _horizontalInput = 0;
    _tiltInput = 0;
  }
}
