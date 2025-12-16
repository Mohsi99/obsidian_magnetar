import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/presentation/screens/bottom_navigation_bar_view/bottom_navigation_bar_screen.dart';
import 'package:obsidian_magnetar/providers/currency_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CurrencyProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: BottomNavigationBarView());
  }
}
