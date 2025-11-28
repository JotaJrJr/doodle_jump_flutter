import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'platform_base.dart';

/// Special boost platform providing stronger jump
class BoostPlatform extends PlatformBase {
  BoostPlatform({
    required Vector2 position,
  }) : super(
         position: position,
         size: Vector2(70, 15),
         jumpBoost: 900, // Stronger jump boost (50% more than normal)
       );
  
  @override
  Color getPlatformColor() => const Color(0xFFFF9800); // Orange - visually distinct
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Add visual indicator (stars/sparkles) to show it's special
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    
    // Draw small decorative circles
    canvas.drawCircle(const Offset(-20, 0), 2, paint);
    canvas.drawCircle(const Offset(20, 0), 2, paint);
    canvas.drawCircle(const Offset(0, -5), 2, paint);
  }
  
  @override
  void onPlayerLand() {
    // Could add particle effects here for visual feedback
    super.onPlayerLand();
  }
}
