import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'app_brand.dart';

/// Compact sidebar that mirrors the cleaner original app:
/// simple icons, text labels, and a rounded yellow active destination.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.selected,
    required this.onSelect,
    this.navigationKey,
    this.footer,
    this.workshop = false,
    super.key,
  });

  final int selected;
  final ValueChanged<int> onSelect;
  final Key? navigationKey;
  final Widget? footer;
  final bool workshop;

  static const labels = <String>[
    'Home',
    'Vocabulary',
    'Grammar',
    'Learning',
    'Speaking',
  ];

  static const icons = <IconData>[
    Icons.home_outlined,
    Icons.menu_book_outlined,
    Icons.import_contacts_outlined,
    Icons.explore_outlined,
    Icons.chat_bubble_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) => Container(
    key: navigationKey,
    color: AppColors.deepNavy,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            const Center(
              child: Column(
                children: [
                  AppRobotLogo(size: 46, invertOnDark: true),
                  SizedBox(height: 6),
                ],
              ),
            ),
            if (workshop) ...[
              const Text(
                'UI WORKSHOP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFACBBD1),
                  letterSpacing: 1.2,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
            ] else
              const SizedBox(height: 12),
            for (var i = 0; i < labels.length; i++) ...[
              _SidebarDestination(
                key: ValueKey('destination-$i'),
                label: labels[i],
                icon: icons[i],
                selected: i == selected,
                onPressed: () => onSelect(i),
              ),
              const SizedBox(height: 8),
            ],
            const Spacer(),
            if (footer != null) Center(child: footer!),
          ],
        ),
      ),
    ),
  );
}

class _SidebarDestination extends StatelessWidget {
  const _SidebarDestination({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFFE7CF78) : Colors.transparent,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.deepNavy : Colors.white,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? AppColors.deepNavy : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
