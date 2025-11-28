import 'package:flutter/material.dart';
import '../viewmodels/leaderboard_view_model.dart';
import '../device_type.dart';
import '../view_layout_manager.dart';

/// Leaderboard screen showing last 10 games
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late LeaderboardViewModel viewModel;
  
  @override
  void initState() {
    super.initState();
    viewModel = LeaderboardViewModel();
    viewModel.loadLeaderboard();
  }
  
  @override
  Widget build(BuildContext context) {
    return ViewLayoutManager<LeaderboardViewModel>(
      viewModel: viewModel,
      pages: {
        DeviceType.mobileVertical: _buildMobileVertical,
        DeviceType.mobileHorizontal: _buildMobileHorizontal,
        DeviceType.tabletVertical: _buildTablet,
        DeviceType.desktop: _buildDesktop,
      },
    );
  }
  
  Widget _buildMobileVertical(LeaderboardViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color(0xFF0175C2),
        foregroundColor: Colors.white,
        actions: [
          if (vm.hasEntries)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmClear(vm),
            ),
        ],
      ),
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
        child: AnimatedBuilder(
          animation: vm,
          builder: (context, _) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            
            if (!vm.hasEntries) {
              return const Center(
                child: Text(
                  'No games played yet!\nStart playing to see your scores here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.entries.length,
              itemBuilder: (context, index) {
                final entry = vm.entries[index];
                final rank = index + 1;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: _getRankColor(rank),
                      child: Text(
                        '#$rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Score: ${entry.score}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Distance: ${entry.maxDistance.toStringAsFixed(0)}m',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vm.formatDate(entry.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: _getRankIcon(rank),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildMobileHorizontal(LeaderboardViewModel vm) {
    return _buildMobileVertical(vm);
  }
  
  Widget _buildTablet(LeaderboardViewModel vm) {
    return _buildMobileVertical(vm);
  }
  
  Widget _buildDesktop(LeaderboardViewModel vm) {
    return _buildMobileVertical(vm);
  }
  
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return const Color(0xFF0175C2);
    }
  }
  
  Widget? _getRankIcon(int rank) {
    if (rank <= 3) {
      return const Icon(
        Icons.emoji_events,
        color: Colors.amber,
        size: 32,
      );
    }
    return null;
  }
  
  void _confirmClear(LeaderboardViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Leaderboard'),
        content: const Text('Are you sure you want to clear all scores?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.clearLeaderboard();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
