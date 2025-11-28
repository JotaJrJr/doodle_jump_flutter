import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flame/components.dart';
import 'dart:math';
import 'platform.dart';

class ObjectManager extends Component with HasGameReference<DoodleJumper> {
  final double spacing = 120;
  final Random random = Random();
  double highestY = 0;

  @override
  Future<void> onLoad() async {
    
    double y = game.size.y;
    while (y > -spacing * 10) {
      final x = random.nextDouble() * (game.size.x - 60);
      final isSpecial = random.nextDouble() < 0.1;
      game.add(Platform(position: Vector2(x, y), isSpecial: isSpecial));
      y -= spacing;
    }
    highestY = y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    
    final cameraY = game.camera.viewport.position.y;
    // final cameraY = game.camera.viewfinder.position.y;  // não sei se é viewport ou viewfinder

    
    
    if (cameraY + game.size.y < highestY + spacing * 5) {
      final x = random.nextDouble() * (game.size.x - 60);
      final isSpecial = random.nextDouble() < 0.1;
      game.add(Platform(
        position: Vector2(x, highestY - spacing),
        isSpecial: isSpecial
      ));
      highestY -= spacing;
    }

    
    final toRemove = game.children
        .whereType<Platform>()
        .where((p) => p.position.y > cameraY + game.size.y)
        .toList();

    for (final platform in toRemove) {
      game.remove(platform);
    }
  }
}