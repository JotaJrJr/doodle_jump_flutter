import 'package:flutter/material.dart';

/// Reusable control button for game controls
class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback? onReleased;
  final String label;
  
  const ControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onReleased,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => onReleased?.call(),
      onTapCancel: () => onReleased?.call(),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }
}
