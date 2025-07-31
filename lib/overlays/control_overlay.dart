import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class ControlOverlay extends StatelessWidget {
  final DoodleJumper game;
  const ControlOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza horizontalmente
          children: [
            GestureDetector(
              onTapDown: (_) => game.player.moveLeft(),
              onTapUp: (_) => game.player.stopMoving(),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.arrow_back, size: 40),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTapDown: (_) => game.player.moveRight(),
              onTapUp: (_) => game.player.stopMoving(),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.arrow_forward, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}