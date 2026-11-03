import 'package:flutter/material.dart';

import '../app/theme.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.paper,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.border),
    ),
    child: Padding(padding: const EdgeInsets.all(24), child: child),
  );
}
