import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/presentation/screens/transactions/widget/transaction_list_item.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/data/model/transactions_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<TransactionModel> _mockTransactions = [];

  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    _mockTransactions.addAll([
      TransactionModel(
        transactionId: '1',
        userId: 'user1',
        type: TransactionType.expense,
        amount: 85.50,
        category: 'Grocery',
        categoryId: 'cat1',
        date: now.subtract(const Duration(hours: 2)),
        note: 'Weekly groceries',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        transactionId: '2',
        userId: 'user1',
        type: TransactionType.expense,
        amount: 24.00,
        category: 'Transport',
        categoryId: 'cat2',
        date: now.subtract(const Duration(days: 1)),
        note: 'Uber ride',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        transactionId: '3',
        userId: 'user1',
        type: TransactionType.income,
        amount: 3500.00,
        category: 'Salary',
        categoryId: 'cat3',
        date: now.subtract(const Duration(days: 2)),
        note: 'Monthly Salary',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        transactionId: '4',
        userId: 'user1',
        type: TransactionType.expense,
        amount: 15.00,
        category: 'Entertainment',
        categoryId: 'cat4',
        date: now.subtract(const Duration(days: 3)),
        note: 'Netflix Subscription',
        isRecurring: true,
        createdAt: now,
        updatedAt: now,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(

          AppStrings.transactions,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.gray50,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.gray900),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.gray900),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: _mockTransactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Income', 'Expense'];
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary500 : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? AppColors.primary500 : Colors.transparent,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary500.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.gray600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppDimensions.lg,
        right: AppDimensions.lg,
        top: AppDimensions.md,
        bottom: 100,
      ),
      itemCount: _mockTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _mockTransactions[index];

        // Simple date header logic (improvement: group properly)
        final bool showHeader = index == 0 ||
            !DateUtils.isSameDay(
                _mockTransactions[index - 1].date, transaction.date);

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
