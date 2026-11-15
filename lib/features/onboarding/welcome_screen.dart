import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/app_brand.dart';
import '../../shared/robot_art.dart';
import '../../shared/ui_art.dart';
import '../profiles/profile_panel.dart';

/// Local-profile entry. No authentication or account backend is implied.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: WarmPageBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 900;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.all(desktop ? 30 : 16),
                    child: desktop
                        ? const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: _StoryPanel(tall: true)),
                              SizedBox(width: 22),
                              Expanded(flex: 5, child: _EntryPanel()),
                            ],
                          )
                        : const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _StoryPanel(tall: false),
                              SizedBox(height: 18),
                              _EntryPanel(),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel({required this.tall});
  final bool tall;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(28),
    child: SizedBox(
      height: tall ? 695 : 350,
      child: Stack(
        children: [
          const Positioned.fill(child: NightStudyScene()),
          Positioned(
            right: tall ? 26 : 8,
            bottom: tall ? 28 : 7,
            child: RobotArt(
              artwork: RobotArtwork.orbOnNavy,
              size: tall ? 160 : 105,
            ),
          ),
          Positioned(
            left: tall ? 35 : 22,
            right: 22,
            top: tall ? 39 : 25,
            child: const AppBrandRow(onDark: true, size: 39),
          ),
          Positioned(
            left: tall ? 45 : 24,
            right: tall ? 40 : 150,
            top: tall ? 150 : 98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好!',
                  style: TextStyle(
                    fontSize: tall ? 60 : 45,
                    fontWeight: FontWeight.w900,
                    color: AppColors.yellow,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'A little Mandarin,\nevery day.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.12,
                    fontSize: tall ? 38 : 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'A gentler, more thoughtful way to learn Chinese.',
                  style: TextStyle(
                    color: const Color(0xFFCAD7E8),
                    fontSize: tall ? 16 : 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (tall)
            const Positioned(
              bottom: 27,
              left: 36,
              child: Text(
                'WORDS · SOUNDS · CONFIDENCE',
                style: TextStyle(
                  color: Color(0xFFC7D1E2),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _EntryPanel extends StatelessWidget {
  const _EntryPanel();

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.paper,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x170C2640),
          blurRadius: 28,
          offset: Offset(0, 12),
        ),
      ],
    ),
    padding: const EdgeInsets.all(26),
    child: ArtBackplate(
      art: UiArtwork.cherryBlossom,
      width: 210,
      height: 140,
      opacity: .19,
      minWidth: 490,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: AppColors.gold, size: 23),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'YOUR LEARNING CORNER',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mutedInk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ready to begin?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const RobotArt(artwork: RobotArtwork.wavingOnPaper, size: 55),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Pick a learner profile or create a fresh start.',
            style: TextStyle(color: AppColors.mutedInk),
          ),
          const SizedBox(height: 20),
          const Material(
            color: AppColors.cream,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            child: Padding(padding: EdgeInsets.all(17), child: ProfilePanel()),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.mutedInk, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Profiles stay on this device. This is not an online password login.',
                  style: TextStyle(fontSize: 11, color: AppColors.mutedInk),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
