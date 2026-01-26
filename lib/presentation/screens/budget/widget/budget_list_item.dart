import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/model/budget_model.dart';
import '../../../../core/data/model/category_model.dart';
import '../../../../providers/category_provider.dart';
import '../../../../providers/currency_provider.dart';

class BudgetListItem extends StatelessWidget {
  final BudgetModel budget;

  const BudgetListItem({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>().currency;
    final percentage = budget.percentage;

    // Find category details
    final categoryProvider = context.watch<CategoryProvider>();
    final category = categoryProvider.categories.firstWhere(
          (c) => c.id == budget.categoryId,
      orElse: () => CategoryModel(
        id: 'unknown',
        name: 'Uncategorized',
        iconCode: Icons.category_outlined.codePoint,
        colorValue: AppColors.gray500.value,
      ),
    );

    // Dynamic color based on usage
    Color progressColor;
    if (percentage < 50) {
      progressColor = const Color(0xFF10B981); // Emerald 500
    } else if (percentage < 85) {
      progressColor = const Color(0xFFF59E0B); // Amber 500
    } else {
      progressColor = const Color(0xFFEF4444); // Red 500
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(category.colorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                    color: Color(category.colorValue),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${percentage.toStringAsFixed(0)}% used',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${currency.symbol}${budget.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                    Text(
                      'Limit',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currency.symbol}${budget.spent.toStringAsFixed(0)} spent',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: progressColor,
                      ),
                    ),
                    Text(
                      '${currency.symbol}${budget.remaining.toStringAsFixed(0)} left',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    backgroundColor: AppColors.gray100,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
