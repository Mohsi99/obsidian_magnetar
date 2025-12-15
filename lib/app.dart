import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/presentation/screens/splash/splash_screen.dart';

import 'core/theme/app_theme.dart';


class FinanceManagerApp extends StatelessWidget {
  const FinanceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
