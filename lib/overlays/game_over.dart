import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  final DoodleJumper game;
  const GameOverMenu(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Game Over', style: TextStyle(fontSize: 32, color: Colors.white)),
        ElevatedButton(
          child: Text('Reiniciar'),
          onPressed: () {
            game.reset();
            game.resumeEngine();
          },
        ),
        ElevatedButton(
          child: Text('Voltar ao Menu'),
          onPressed: () {
            game.reset();
          },
        ),
      ],
    );
  }
}