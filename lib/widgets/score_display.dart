import 'package:flutter/material.dart';

/// Widget to display current score during gameplay
class ScoreDisplay extends StatelessWidget {
  final int score;
  
  const ScoreDisplay({
    super.key,
    required this.score,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Score: $score',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
