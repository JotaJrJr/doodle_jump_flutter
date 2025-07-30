import 'package:flame/components.dart';
import 'dart:math';
import 'platform.dart';

class ObjectManager extends Component {
  final double spacing = 120;
  final Random random = Random();
  double highestY = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Gera plataformas iniciais
    double y = owner!.size.y;
    while (y > -spacing * 10) {
      final x = random.nextDouble() * (owner!.size.x - 60);
      add(Platform(position: Vector2(x, y)));
      y -= spacing;
    }
    highestY = y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Quando o jogador sobe, gera novas plataformas acima
    final cameraY = owner!.camera.position.y;
    if (cameraY + owner!.size.y < highestY + spacing * 5) {
      final x = random.nextDouble() * (owner!.size.x - 60);
      add(Platform(position: Vector2(x, highestY - spacing)));
      highestY -= spacing;
    }

    // Remove plataformas abaixo
    owner!.children.whereType<Platform>().where((p) => p.position.y > cameraY + owner!.size.y).toList().forEach(remove);
  }
}