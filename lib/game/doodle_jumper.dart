import 'package:doodle_jump/game/player.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'object_manager.dart';

class DoodleJumper extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  late Player player;
  late ObjectManager objectManager;

  double gravity = 800;
  double initialPlayerY = 0;

  // TODO : Rever isso, tá calculando só a subida, caso desça ele não muda o valor
  // Ele conta cada vez que encosta numa plataforma, não necessariamente quando passa por elas, então ele incrementa também quando cai na mesma plataforma
  ValueNotifier<int> platformsPassedNotifier = ValueNotifier(0);
  ValueNotifier<double> maxHeightNotifier = ValueNotifier(0);

  int _platformsPassed = 0;
  int get platformsPassed => _platformsPassed;
  set platformsPassed(int value) {
    _platformsPassed = value;
    platformsPassedNotifier.value = value;
  }

  double _maxHeight = 0;
  double get maxHeight => _maxHeight;
  set maxHeight(double value) {
    _maxHeight = value;
    maxHeightNotifier.value = value;
  }

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(360, 640));
    initialPlayerY = size.y - 100; // guard a aposição inicial do player

    player = Player(position: Vector2(size.x / 2, size.y - 100));
    add(player);

    objectManager = ObjectManager();
    add(objectManager);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Atualizar câmera para seguir subida
    // Parece que não é o moveTo
    // double currentHeight = initialPlayerY - player.position.y;
    // if (currentHeight > maxHeight) {
    //   maxHeight = currentHeight;
    // }

    // double targetCameraY = player.position.y - size.y * 0.7; // mantém no 1/3 de baixo

    // double targetCameraY = player.position.y - 128;

    // if (targetCameraY < camera.viewfinder.position.y) {
    //   camera.moveTo(Vector2(0, targetCameraY));
    // }

    //   if (player.position.y < maxHeight) {
    //   maxHeight = player.position.y;
    //   camera.moveTo(Vector2(0, maxHeight - size.y / 2));
    // }

    double currentHeight = initialPlayerY - player.position.y;

    if (currentHeight > maxHeightNotifier.value) {
      // maxHeightNotifier.value = currentHeight;
      maxHeight = currentHeight;
    }

    double halfHeight = size.y / 2;
    double f = 0.7;
    double offset = f * size.y - halfHeight;

    double targetCameraY = player.position.y - offset;

    if (targetCameraY < camera.viewfinder.position.y) {
      camera.moveTo(Vector2(0, targetCameraY));
    }
  }

  void reset() {
    // platformsPassedNotifier.value = 0;
    // maxHeightNotifier.value = 0;

    platformsPassed = 0;
    maxHeight = 0;

    // Remove todos os componentes
    children.where((c) => c is! CameraComponent).forEach(remove);

    // Recria os componentes principais
    player = Player(position: Vector2(size.x / 2, size.y - 100));
    add(player);

    objectManager = ObjectManager();
    add(objectManager);

    // Reseta a câmera
    camera.moveTo(Vector2(0, 0));

    overlays.removeAll(['GameOver', 'PauseMenu', 'Controls', 'Score']);
    overlays.add('MainMenu');

    resumeEngine();
  }

  void pauseGame() {
    pauseEngine();
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    resumeEngine();
    overlays.remove('PauseMenu');
  }

  void gameOver() {
    pauseEngine();
    overlays.add('GameOver');
  }
}
