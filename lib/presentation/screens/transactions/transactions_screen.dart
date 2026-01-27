import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/presentation/screens/transactions/widget/transaction_list_item.dart';
import 'package:provider/provider.dart';

import '../../../core/data/model/transactions_model.dart';
import '../../../providers/transaction_provider.dart';
import 'search_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.gray900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppStrings.transactions,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          /*IconButton(
            icon: Icon(Icons.filter_list, color: textColor),
            onPressed: () {
               // Filter implementation to be updated later if needed
            },
          ),*/
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.transactions.isEmpty) {
            return _buildEmptyState();
          }

          return _buildTransactionList(provider.transactions);
        },
      ),
    );
  }

  // Removed _buildFilterTabs

  Widget _buildTransactionList(List<TransactionModel> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppDimensions.lg,
        right: AppDimensions.lg,
        top: AppDimensions.md,
        bottom: 100,
      ),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        // Simple date header logic (improvement: group properly)
        final bool showHeader = index == 0 ||
            !DateUtils.isSameDay(
                transactions[index - 1].date, transaction.date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              if (index > 0) const SizedBox(height: AppDimensions.lg),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  _formatDate(transaction.date).toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.gray500,
                        // Kept gray500 as it's typically fine for labels in both modes
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                ),
              ),
            ],
            TransactionListItem(transaction: transaction),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.gray300),
          const SizedBox(height: AppDimensions.md),
          Text(
            'No transactions found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.gray500,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (DateUtils.isSameDay(date, now)) return 'Today';
    if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1))))
      return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}
