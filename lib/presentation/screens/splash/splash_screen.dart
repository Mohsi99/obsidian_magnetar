import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:obsidian_magnetar/presentation/screens/bottom_navigation_bar_view/bottom_navigation_bar_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../on_boarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (!mounted) return;


          if (user == null) {
            Timer(const Duration(seconds: 3), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingScreen(),
                  ));
            });
          } else {
            Timer(const Duration(seconds: 3), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationBarView(),
                  ));
            });
          }
        });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                AppStrings.appName,
                style: Theme
                    .of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                AppStrings.appTagline,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

}
