import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final DoodleJumper game;
  const PauseMenu(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('Continuar'),
        onPressed: () => game.resumeGame(),
      ),
    );
  }}