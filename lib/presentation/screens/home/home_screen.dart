import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

import '../../../core/data/model/transactions_model.dart';
import '../../../providers/currency_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../auth/login_screen.dart';
import '../transactions/transactions_screen.dart';
import '../transactions/widget/transaction_list_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          final transactions = transactionProvider.transactions;
          // Calculate total expense
          double totalExpense = 0;
          for (var t in transactions) {
            totalExpense += t.amount;
          }

          return CustomScrollView(
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
                      _buildDashboardContent(context, totalExpense, transactions),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, double totalExpense, List<TransactionModel> transactions) {
    final currencySymbol = context.watch<CurrencyProvider>().currency.symbol;
    final recentTransactions = transactions.take(5).toList();

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
                'Total Spent', // Changed from Total Balance as we track expenses
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$currencySymbol${totalExpense.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.xl2),
        // Hidden Summary Cards for now as we don't have income
        /*
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                AppStrings.income,
                '$currencySymbol' '0.00',
                AppColors.success500,
                Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: AppDimensions.lg),
            Expanded(
              child: _buildSummaryCard(
                AppStrings.expense,
                '$currencySymbol${totalExpense.toStringAsFixed(2)}',
                AppColors.danger500,
                Icons.arrow_downward,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.xl2),
        */
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
        const SizedBox(height: 12),
        if (recentTransactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No transactions yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.gray500),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTransactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return TransactionListItem(
                transaction: recentTransactions[index],
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
