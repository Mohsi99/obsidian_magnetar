import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/contants/app_colors.dart';
import '../../../../core/model/transactions_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444); // More vibrant colors

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Category Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isIncome ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: amountColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray900,
                      fontSize: 16,
                    ),
                  ),
                  if (transaction.note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      transaction.note!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.gray500,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                    fontSize: 16,
                  ),
                ),
                if (transaction.isRecurring)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.repeat,
                      size: 14,
                      color: AppColors.gray400,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    // Simple mapping for now
    switch (category.toLowerCase()) {
      case 'grocery':
        return Icons.shopping_basket_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'salary':
        return Icons.attach_money;
      case 'entertainment':
        return Icons.movie_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
