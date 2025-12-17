import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/presentation/screens/transactions/transactions_screen.dart';
import 'package:provider/provider.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/data/model/transactions_model.dart';
import '../../../providers/currency_provider.dart';
import '../auth/login_screen.dart';
import '../transactions/widget/transaction_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TransactionModel> _recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    _recentTransactions.addAll([
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.gray50,
            elevation: 0,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            title: const Text(AppStrings.dashboard),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.lg,
              AppDimensions.lg,
              AppDimensions.lg,
              AppDimensions.lg + 80,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildDashboardContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.xl2),
          decoration: BoxDecoration(
            gradient: AppColors.balanceCardGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary500.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.totalBalance,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${context.watch<CurrencyProvider>().currency.symbol}0.00',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.xl2),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                AppStrings.income,
                '${context.watch<CurrencyProvider>().currency.symbol}0.00',
                AppColors.success500,
                Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: AppDimensions.lg),
            Expanded(
              child: _buildSummaryCard(
                AppStrings.expense,
                '${context.watch<CurrencyProvider>().currency.symbol}\$0.00',
                AppColors.danger500,
                Icons.arrow_downward,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.xl2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recentTransactions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TransactionsScreen(),
                  ),
                );
              },
              child: const Text(AppStrings.seeAll),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentTransactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return TransactionListItem(
              transaction: _recentTransactions[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
