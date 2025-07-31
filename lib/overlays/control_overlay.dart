import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flutter/material.dart';

class ControlOverlay extends StatelessWidget {
  final DoodleJumper game;
  const ControlOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          bottom: 20,
          child: Row(
            children: [
              GestureDetector(
                onTapDown: (_) => game.player.moveLeft(),
                onTapUp: (_) => game.player.stopMoving(),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.arrow_back, size: 40),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTapDown: (_) => game.player.moveRight(),
                onTapUp: (_) => game.player.stopMoving(),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.arrow_forward, size: 40),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}