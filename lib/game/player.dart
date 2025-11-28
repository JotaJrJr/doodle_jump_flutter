import 'dart:async';

import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'platform.dart';

class Player extends PositionComponent
    with HasGameReference<DoodleJumper>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  final double jumpSpeed = -450;
  final double moveSpeed = 200;

  final StreamController<Rect> cameraStreamController;
  double horizontalDirection = 0.0;

  Player({
    required Vector2 position,
    required this.cameraStreamController,
  }) : super(position: position, size: Vector2(90, 90), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    debugMode = true;
    add(CircleHitbox(
      
    ));

    if (game.buildContext != null &&
        MediaQuery.of(game.buildContext!).size.shortestSide < 600) {
      accelerometerEventStream().listen((AccelerometerEvent event) {
        horizontalDirection = event.x * 2;
      });
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity.y += 800 * dt;
    position += velocity * dt;

    position.x += horizontalDirection * moveSpeed * dt;

    if (position.x < -width / 2) {
      position.x = game.size.x + width / 2;
    } else if (position.x > game.size.x + width / 2) {
      position.x = -width / 2;
    }

    if (position.y < game.size.y / 2) {
      final diff = game.size.y / 2 - position.y;
      position.y = game.size.y / 2;
      game.children.whereType<Platform>().forEach((platform) {
        platform.position.y += diff;
      });

      cameraStreamController.add(Rect.fromLTWH(0, -position.y, game.size.x, game.size.y));
    }

    if (position.y > game.size.y) {
      // game.resetGame();
    }
  }

    void moveLeft() {
    horizontalDirection = -1;
    // isMovingLeft = true;
  }

  void moveRight() {
    horizontalDirection = 1;
  }
  void stopMoving() {
    horizontalDirection = 0;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
  }
}