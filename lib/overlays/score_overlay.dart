import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class ScoreOverlay extends StatelessWidget {
  final DoodleJumper game;
  const ScoreOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListenableBuilder(
      listenable: Listenable.merge(
        [
          game.platformsPassedNotifier, game.maxHeightNotifier
        ]
      ),
      builder: (_, __) {
        return Positioned(
          top: size.height * 0.5,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plataformas: ${game.platformsPassed}', style: TextStyle(color: Colors.white)),
              Text('Altura: ${(-game.maxHeight).toInt()}', style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      }
    );
  }
}