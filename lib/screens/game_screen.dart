import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/flutter_jump_game.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/control_button.dart';
import '../widgets/score_display.dart';

/// Game screen hosting the FlameGame widget
/// Includes on-screen controls and score display
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FlutterJumpGame game;
  late GameViewModel viewModel;
  
  @override
  void initState() {
    super.initState();
    
    viewModel = GameViewModel();
    
    game = FlutterJumpGame(
      onScoreUpdate: (score) {
        viewModel.updateScore(score);
      },
      onGameOver: () async {
        await viewModel.gameOver();
        if (mounted) {
          _showGameOverDialog();
        }
      },
    );
    
    viewModel.startGame();
    
    // Start sensor update loop
    _startSensorUpdateLoop();
  }
  
  /// Continuously update game with sensor tilt values
  void _startSensorUpdateLoop() {
    // Update every frame (60 FPS)
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16)); // ~60 FPS
      
      if (!mounted) return false;
      
      // Apply tilt input to game if sensor is enabled
      if (viewModel.useSensor && viewModel.sensorAvailable) {
        game.setTiltMovement(viewModel.sensorService.tiltValue);
      }
      
      return true;
    });
  }
  
  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game widget (fullscreen)
          GameWidget(game: game),
          
          // Score display (top center)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: viewModel,
                builder: (context, _) {
                  return ScoreDisplay(score: viewModel.currentScore);
                },
              ),
            ),
          ),
          
          // Control buttons (bottom sides)
          Positioned(
            bottom: 50,
            left: 30,
            child: ControlButton(
              icon: Icons.arrow_back,
              label: 'Left',
              onPressed: () => game.moveLeft(),
              onReleased: () => game.stopMovement(),
            ),
          ),
          
          Positioned(
            bottom: 50,
            right: 30,
            child: ControlButton(
              icon: Icons.arrow_forward,
              label: 'Right',
              onPressed: () => game.moveRight(),
              onReleased: () => game.stopMovement(),
            ),
          ),
          
          // Sensor toggle (top right) - only show if sensor available
          AnimatedBuilder(
            animation: viewModel,
            builder: (context, _) {
              if (!viewModel.sensorAvailable) return const SizedBox();
              
              return Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    viewModel.useSensor ? Icons.sensors : Icons.sensors_off,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () => viewModel.toggleSensor(),
                ),
              );
            },
          ),
          
          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Show game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Final Score: ${viewModel.currentScore}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Your score has been saved!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home
            },
            child: const Text('Home'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Restart game
              game.resetGame();
              viewModel.startGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
