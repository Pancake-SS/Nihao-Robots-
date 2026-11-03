import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/robot_art.dart';

/// Bootstrap composition only; local profile entry is the next vertical slice.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1000 &&
                MediaQuery.textScalerOf(context).scale(16) <= 24;
            return SingleChildScrollView(
              padding: EdgeInsets.all(constraints.maxWidth < 700 ? 16 : 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NI HAO ROBOT!', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      const Text('A little Mandarin, every day.'),
                      const SizedBox(height: 32),
                      if (wide)
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _WelcomeCard()),
                            SizedBox(width: 24),
                            Expanded(flex: 2, child: _CompanionCard()),
                          ],
                        )
                      else
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _WelcomeCard(),
                            SizedBox(height: 24),
                            _CompanionCard(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('你好！', style: textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Your Mandarin journey starts here.', style: textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(
            'Meet your learning companions. Take your time, stay curious, '
            'and make room for a little progress each day.',
            style: textTheme.bodyLarge,
          ),
          const Center(child: RobotArt(artwork: RobotArtwork.wavingOnPaper)),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Coming soon: local learner profiles and your first lesson.'),
          ),
        ],
      ),
    );
  }
}

class _CompanionCard extends StatelessWidget {
  const _CompanionCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Small steps.\nNew possibilities.',
            style: textTheme.headlineSmall?.copyWith(color: AppColors.yellow),
          ),
          const SizedBox(height: 16),
          Text(
            'A cozy place to begin understanding, remembering, and using Mandarin.',
            style: textTheme.bodyLarge?.copyWith(color: AppColors.paper),
          ),
          const SizedBox(height: 16),
          const Center(child: RobotArt(artwork: RobotArtwork.orbOnNavy)),
        ],
      ),
    );
  }
}
