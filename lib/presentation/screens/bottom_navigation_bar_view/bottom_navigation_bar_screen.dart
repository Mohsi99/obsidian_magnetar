import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obsidian_magnetar/presentation/screens/profile/profile_screen.dart';
import 'package:obsidian_magnetar/presentation/screens/transactions/transactions_screen.dart';

import '../budget/budget_screen.dart';
import '../home/home_screen.dart';
import '../placeholder_screen.dart';
import '../transactions/add_transaction_screen.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() => _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  int index = 0;

  void onChange(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      const TransactionsScreen(),
      const BudgetScreen(),
      const PlaceholderScreen(title: 'Analytics', icon: Icons.analytics),
      const ProfileScreen()

    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          screens.elementAt(index),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: BottomNavigationBar(
                  elevation: 0,
                  selectedItemColor: const Color(0xff27272E),
                  type: BottomNavigationBarType.fixed,
                  unselectedItemColor: const Color(0xff464646).withOpacity(0.9),
                  showUnselectedLabels: true,
                  selectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff27272E),
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff464646).withOpacity(0.9),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  currentIndex: index,
                  onTap: onChange,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined, size: 20),
                      activeIcon: Icon(Icons.home, size: 20),
                      label: "HOME",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long_outlined, size: 20),
                      activeIcon: Icon(Icons.receipt_long, size: 20),
                      label: "Transactions",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_balance_wallet_outlined, size: 20),
                      activeIcon: Icon(Icons.account_balance_wallet, size: 20),
                      label: "Budgets",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.analytics_outlined, size: 20),
                      activeIcon: Icon(Icons.analytics, size: 20),
                      label: "Analytics",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline, size: 20),
                      activeIcon: Icon(Icons.person, size: 20),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: index == 0
          ? Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xff27272E),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      )
          : null,
    );
  }
}
