import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'platform_base.dart';

/// Standard platform providing normal jump boost
class NormalPlatform extends PlatformBase {
  NormalPlatform({
    required Vector2 position,
  }) : super(
         position: position,
         size: Vector2(70, 15),
         jumpBoost: 600, // Standard jump strength
       );
  
  @override
  Color getPlatformColor() => const Color(0xFF4CAF50); // Green
}
