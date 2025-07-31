import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Platform extends PositionComponent with CollisionCallbacks {

  final bool isSpecial;
  Platform({required Vector2 position, this.isSpecial = false})
      : super(position: position, size: Vector2(60, 10), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if(isSpecial) {
      canvas.drawRect(size.toRect(), Paint()..color = Colors.yellow);
    } else {
      canvas.drawRect(size.toRect(), Paint()..color = Colors.brown);
    }
  }
}