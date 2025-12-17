import 'package:flutter/material.dart';

class AppColors {
  static const Color primary500 = Color(0xFF6366F1);
  static const Color primary600 = Color(0xFF4F46E5);
  static const Color primary700 = Color(0xFF4338CA);
  static const Color primary100 = Color(0xFFE0E7FF);

  static const Color success500 = Color(0xFF10B981);
  static const Color success600 = Color(0xFF059669);
  static const Color success100 = Color(0xFFD1FAE5);

  static const Color danger500 = Color(0xFFEF4444);
  static const Color danger600 = Color(0xFFDC2626);
  static const Color danger100 = Color(0xFFFEE2E2);

  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning100 = Color(0xFFFEF3C7);

  static const Color info500 = Color(0xFF3B82F6);
  static const Color info600 = Color(0xFF2563EB);
  static const Color info100 = Color(0xFFDBEAFE);

  static const Color gray900 = Color(0xFF111827);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray500 = Color(0xFF4B5560);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color white = Color(0xFFFFFFFF);

  static const Color budgetSafe = success500;
  static const Color budgetWarning = warning500;
  static const Color budgetDanger = Color(0xFFFB923C);
  static const Color budgetCritical = danger500;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary500, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient balanceCardGradient = LinearGradient(
    colors: [primary500, primary600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
