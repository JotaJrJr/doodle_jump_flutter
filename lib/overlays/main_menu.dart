import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final DoodleJumper game;
  const MainMenu(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('Iniciar Jogo'),
        onPressed: () {
          game.overlays.remove('MainMenu');
          game.resumeEngine();
        },
      ),
    );
  }
}