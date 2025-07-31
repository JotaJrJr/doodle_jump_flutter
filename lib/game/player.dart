
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

  Player({required Vector2 position})
    : super(position: position, size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    
    // acelerômetro
    if (game.buildContext != null &&
        MediaQuery.of(game.buildContext!).size.shortestSide < 600) {
      // accelerometerEvents.listen((AccelerometerEvent event) {
      //   horizontalDirection = event.x * 2;
      // });

      accelerometerEventStream().listen((AccelerometerEvent event) {
        horizontalDirection = event.x * 2;
      });
    }
  }

  double horizontalDirection = 0;
  bool isMovingLeft = false;
  bool isMovingRight = false;

  @override
  void update(double dt) {
    // Aplica movimento
    velocity.x = horizontalDirection * moveSpeed;
    
    // Física do jogador
    velocity.y += game.gravity * dt;
    position += velocity * dt;

    // Loop horizontal pra ir da direita e brotar na esquerda vice versa
    if (position.x < 0) position.x = game.size.x;
    if (position.x > game.size.x) position.x = 0;

    // Cabo
    // if (position.y > game.camera.viewport.position.y + game.size.y) {
    //   game.gameOver();
    // }

    double screenBottom = game.camera.viewport.position.y + game.size.y;
    if (position.y > screenBottom) {
      game.gameOver();
    }
  }

  void moveLeft() {
    horizontalDirection = -1;
    isMovingLeft = true;
  }

  void moveRight() {
    horizontalDirection = 1;
    isMovingRight = true;
  }

  void stopMoving() {
    horizontalDirection = 0;
    isMovingLeft = false;
    isMovingRight = false;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    
    if (other is Platform && velocity.y > 0) {
      if(!other.isSpecial) {
        velocity.y = jumpSpeed;
      } else {
        velocity.y = jumpSpeed * 1.5;
      }
      game.platformsPassed = game.platformsPassed + 1;
    }
  }
}