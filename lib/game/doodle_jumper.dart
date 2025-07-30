import 'package:doodle_jump/game/player.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'object_manager.dart';

class DoodleJumper extends FlameGame with HasCollisionDetection, KeyboardEvents {

  late Player player;
  late ObjectManager objectManager;

  double gravity = 800;
  int platformSpeed = 0;
  double maxHeight = 0;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(360, 640));

    player = Player(position: Vector2(size.x / 2, size.y - 100), velocity: Vector2(0, 0));
    add(player);

    objectManager = ObjectManager();
    add(objectManager);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Atualizar câmera para seguir subida
    if (player.position.y < maxHeight) {
      maxHeight = player.position.y;
      camera.snapTo(Vector2(0, maxHeight - size.y / 2));
    }
  }

  void reset() {
    // Limpa componentes, reinicia variáveis e volta ao menu
    children.clear();
    platformsPassed = 0;
    maxHeight = 0;
    overlays.remove('GameOver');
    overlays.add('MainMenu');
    onLoad();
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