import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/geometry.dart';

class Platform extends PositionComponent with CollisionCallbacks {
  Platform({required Vector2 position}) : super(position: position, size: Vector2(60, 10)) {
    anchor = Anchor.center;
    // addShape(HitboxRectangle());
    addShape(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.brown);
  }
}