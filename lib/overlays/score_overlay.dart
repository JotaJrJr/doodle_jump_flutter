import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class ScoreOverlay extends StatelessWidget {
  final DoodleJumper game;
  const ScoreOverlay(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plataformas: ${game.platformsPassed}', style: TextStyle(color: Colors.white)),
          Text('Altura: ${(-game.maxHeight).toInt()}', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}