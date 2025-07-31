import 'package:doodle_jump/game/doodle_jumper.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'overlays/control_overlay.dart';
import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';
import 'overlays/pause_menu.dart';
import 'overlays/score_overlay.dart';

void main() {
  runApp(
    GameWidget(
      game: DoodleJumper(),
      overlayBuilderMap: {
        'MainMenu': (ctx, DoodleJumper game) => MainMenu(game),
        'PauseMenu': (ctx, DoodleJumper game) => PauseMenu(game),
        'GameOver': (ctx, DoodleJumper game) => GameOverMenu(game),
        'Score': (ctx, DoodleJumper game) => ScoreOverlay(game),
        'Controls': (ctx, DoodleJumper game) => ControlOverlay(game),
      },
      initialActiveOverlays: ['MainMenu'],
    )
  );
}
