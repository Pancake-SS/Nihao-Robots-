import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/robot_art.dart';
import 'profile.dart';

class ProfileHomeScreen extends StatelessWidget {
  const ProfileHomeScreen({required this.profile, super.key});

  final LearnerProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your learning space')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${profile.name}!',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your local profile is ready. You can come back to it on this device.',
                  ),
                  const Center(
                    child: RobotArt(artwork: RobotArtwork.trackedOnPaper),
                  ),
                  Text(
                    '${profile.dailyMinutes} minutes a day · ${profile.goal.label}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text('Starting level: ${profile.level.label}'),
                  Text('Pinyin support: ${profile.showPinyin ? 'on' : 'off'}'),
                  const SizedBox(height: 24),
                  const Text(
                    'Your first lessons are coming next. No learning activity has been recorded yet.',
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Switch profile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
