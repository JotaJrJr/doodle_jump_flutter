import 'dart:io';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

import 'doodle_jumper.dart';

class Player extends PositionComponent with HasGameReference<DoodleJumper>, CollisionCallbacks {

  Vector2 velocity = Vector2(0, 0);

  final double jumpSpeed = -450;
  final double moveSpeed = 200;

  Player({
    required this.velocity, required Vector2 position
  }) : super(position: position, size: Vector2(50, 50)) {
    anchor = Anchor.center;
    addShape(CircleHitbox());
  }


  @override
  void update(double dt) {
    super.update(dt);
    velocity.y += gameRef.gravity * dt;
    position += velocity * dt;

    // Loop horizontal
    if (position.x < 0) position.x = gameRef.size.x;
    if (position.x > gameRef.size.x) position.x = 0;

    // Game Over
    if (position.y > gameRef.camera.position.y + gameRef.size.y) {
      gameRef.gameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Platform && velocity.y > 0) {
      velocity.y = jumpSpeed;
      gameRef.platformsPassed++;
    }
  }
  
}