import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/model/budget_model.dart';
import '../../../../core/data/model/category_model.dart';
import '../../../../core/data/model/transactions_model.dart';

import '../../../../providers/budget_provider.dart';
import '../../../../providers/category_provider.dart';
import '../../../../providers/currency_provider.dart';
import '../../../../providers/transaction_provider.dart';
import '../add_transaction_screen.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>().currency;

    // 1. Find the Budget using budgetId
    final budgetProvider = context.watch<BudgetProvider>();
    BudgetModel? budget;
    try {
      budget = budgetProvider.budgets
          .firstWhere((b) => b.id == transaction.budgetId);
    } catch (_) {}

    // 2. Find the Category using budget.categoryId
    final categoryProvider = context.watch<CategoryProvider>();
    CategoryModel? category;
    if (budget != null) {
      try {
        category = categoryProvider.categories
            .firstWhere((c) => c.id == budget!.categoryId);
      } catch (_) {}
    }

    // If budget or category is missing (deleted?), handle gracefully
    final categoryName = category?.name ?? 'Uncategorized';
    final categoryIcon = category != null
        ? IconData(category.iconCode, fontFamily: 'MaterialIcons')
        : Icons.help_outline;
    final categoryColor =
        category != null ? Color(category.colorValue) : AppColors.gray400;

    final amountColor = AppColors.gray900;

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
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                categoryIcon,
                color: categoryColor,
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
                    categoryName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                          fontSize: 16,
                        ),
                  ),
                  if (transaction.note != null &&
                      transaction.note!.isNotEmpty) ...[
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
                  '-${currency.symbol}${transaction.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            // Edit/Delete Menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.gray400),
              onSelected: (value) {
                if (value == 'edit') {
                  // Navigate to AddTransactionScreen in edit mode
                  // We need to import the screen first, assuming it will handle arguments
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddTransactionScreen(transactionToEdit: transaction),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, budget);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20, color: AppColors.gray600),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: AppColors.danger500),
                      SizedBox(width: 8),
                      Text('Delete',
                          style: TextStyle(color: AppColors.danger500)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BudgetModel? budget) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
            'Are you sure you want to delete this transaction? The amount will be refunded to your budget.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                final budgetProvider = context.read<BudgetProvider>();
                await context.read<TransactionProvider>().deleteTransaction(
                      transaction.id,
                      budgetProvider,
                      transaction.budgetId,
                      transaction.amount,
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Transaction deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting transaction: $e')),
                  );
                }
              }
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger500)),
          ),
        ],
      ),
    );
  }
}
