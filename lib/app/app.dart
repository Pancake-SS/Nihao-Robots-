import 'package:flutter/material.dart';

import '../features/onboarding/welcome_screen.dart';
import 'theme.dart';

class NiHaoRobotApp extends StatelessWidget {
  const NiHaoRobotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ni Hao Robot!',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const WelcomeScreen(),
    );
  }
}
