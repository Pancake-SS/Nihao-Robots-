import 'package:flutter/material.dart';

import '../app/theme.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({required this.child, this.background, super.key});
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: background ?? AppColors.paper,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x120F2943),
          blurRadius: 25,
          offset: Offset(0, 8),
        ),
      ],
    ),
    padding: const EdgeInsets.all(23),
    child: child,
  );
}
