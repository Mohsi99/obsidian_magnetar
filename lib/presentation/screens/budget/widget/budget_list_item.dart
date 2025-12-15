import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obsidian_magnetar/core/contants/app_colors.dart';
import 'package:obsidian_magnetar/core/model/budget_model.dart';

class BudgetListItem extends StatelessWidget {
  final BudgetModel budget;

  const BudgetListItem({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final percentage = budget.percentage;
    final isExceeded = percentage > 200;
    Color progressColor;
    if (percentage < 50) {
      progressColor = const Color(0xFF10B981);
    } else if (percentage < 85) {
      progressColor = const Color(0xFFF59E0B);
    } else {
      progressColor = const Color(0xFFEF4444);
    }
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gray100),
                  ),
                  child: Icon(
                    _getCategoryIcon(budget.categoryId),
                    color: AppColors.gray900,
                    size: 24,
                  ),
                ),          const SizedBox(width: 16),
                Expanded(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_formatCategoryName(budget.categoryId),style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray900,
                    ),

                    ),SizedBox(height: 4,),
                    Text('${percentage.toStringAsFixed(0)}% used',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray500,
                      ),),
                    Text("Limit",style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray400,
                      letterSpacing: 0.5,
                    ),),

                  ],
                ))
              ],
            ),
            const SizedBox(height: 20),
Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('\$${budget.spent.toStringAsFixed(0)} spent',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),),
        Text('\$${budget.remaining.toStringAsFixed(0)} left',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),),
      ],
    ),
    const SizedBox(height: 10),ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: (percentage / 100).clamp(0.0, 1.0),
        backgroundColor: AppColors.gray100,
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        minHeight: 10,
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'grocery':
        return Icons.shopping_cart_outlined;
      case 'transport':
        return Icons.directions_bus_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'bills':
        return Icons.receipt_long_outlined;
      case 'food':
        return Icons.restaurant_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  String _formatCategoryName(String id) {
    return id.substring(0, 1).toUpperCase() + id.substring(1).toLowerCase();
  }
}
