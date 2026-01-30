import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flutter_jump_game.dart';

/// Base class for all platform types
abstract class PlatformBase extends PositionComponent
    with HasGameReference<FlutterJumpGame> {
  final double jumpBoost;

  PlatformBase({
    required Vector2 position,
    required Vector2 size,
    required this.jumpBoost,
  }) : super(position: position, size: size, anchor: Anchor.center);

  /// Called when player lands on this platform
  void onPlayerLand() {
    // Override in subclasses for special effects
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check collision with player
    game.checkPlatformCollision(this);
  }

  /// Get platform color
  Color getPlatformColor();

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw platform as a rounded rectangle
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: size.x,
      height: size.y,
    );

    final paint = Paint()
      ..color = getPlatformColor()
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      borderPaint,
    );
  }
}
