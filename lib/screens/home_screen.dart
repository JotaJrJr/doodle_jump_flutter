import 'package:flutter/material.dart';
import '../device_type.dart';
import '../view_layout_manager.dart';

/// Home screen with responsive layouts
/// Displays game logo, Start button, and Leaderboard button
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ViewLayoutManager<HomeScreen>(
      viewModel: this,
      pages: {
        DeviceType.mobileVertical: _buildMobileVertical,
        DeviceType.mobileHorizontal: _buildMobileHorizontal,
        DeviceType.tabletVertical: _buildTablet,
        DeviceType.desktop: _buildDesktop,
      },
    );
  }
  
  /// Mobile vertical layout
  Widget _buildMobileVertical(HomeScreen viewModel) {
    return Builder(
      builder: (context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0175C2),
                Color(0xFF13B9FD),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Game logo/title
                  const Icon(
                    Icons.flutter_dash,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Flutter Jump',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Start button
                  _buildButton(
                    context,
                    label: 'Start Game',
                    icon: Icons.play_arrow,
                    onPressed: () => Navigator.pushNamed(context, '/game'),
                  ),
                  const SizedBox(height: 20),
                  // Leaderboard button
                  _buildButton(
                    context,
                    label: 'Leaderboard',
                    icon: Icons.leaderboard,
                    onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Mobile horizontal layout
  Widget _buildMobileHorizontal(HomeScreen viewModel) {
    return _buildMobileVertical(viewModel); // Same layout for now
  }
  
  /// Tablet layout
  Widget _buildTablet(HomeScreen viewModel) {
    return _buildMobileVertical(viewModel); // Same layout, just scales better
  }
  
  /// Desktop/widescreen layout
  Widget _buildDesktop(HomeScreen viewModel) {
    return _buildMobileVertical(viewModel); // Same layout
  }
  
  /// Build styled button
  Widget _buildButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0175C2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
    );
  }
}
