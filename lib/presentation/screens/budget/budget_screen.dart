import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obsidian_magnetar/presentation/screens/budget/widget/budget_list_item.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/currency_provider.dart';
import 'add_budget_screen.dart';


class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProvider, child) {
          final budgets = budgetProvider.budgets;
          final isLoading = budgetProvider.isLoading;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final isDark = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDark ? Colors.white : AppColors.gray900;
          final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

          // Calculate totals only if budgets exist
          final totalBudget = budgets.fold(0.0, (sum, item) => sum + item.amount);
          final totalSpent = budgets.fold(0.0, (sum, item) => sum + item.spent);
          final totalRemaining = totalBudget - totalSpent;

          double overallProgress = 0.0;
          if (totalBudget > 0) {
            overallProgress = (totalSpent / totalBudget).clamp(0.0, 1.0);
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: scaffoldBg,
                floating: true,
                snap: true,
                elevation: 0,
                title: Text(
                  'My Budgets',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Theme.of(context).cardTheme.color : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? AppColors.gray600 : AppColors.gray200),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: isDark ? Colors.white70 : AppColors.gray600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Only show summary card if there are budgets
                      if (budgets.isNotEmpty) ...[
                        _BudgetSummaryCard(
                          totalBudget: totalBudget,
                          totalSpent: totalSpent,
                          totalRemaining: totalRemaining,
                          progress: overallProgress,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Limits',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            _buildCreateButton(context),
                          ],
                        ),
                      ] else ...[
                        // Empty State
                        const SizedBox(height: 100),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primary100.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 48,
                                  color: AppColors.primary500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No Budgets Yet',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create a budget to track your spending',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.gray500,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildCreateButton(context, isLarge: true),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      if (budgets.isNotEmpty)
                        ...budgets
                            .map((budget) => BudgetListItem(budget: budget))
                            .toList(),
                      const SizedBox(height: 80),
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

  Widget _buildCreateButton(BuildContext context, {bool isLarge = false}) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBudgetScreen(),
            ));
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 32 : 12, vertical: isLarge ? 16 : 8),
        backgroundColor:
        isLarge ? AppColors.primary500 : AppColors.primary500.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create New Budget',
            style: GoogleFonts.inter(
              fontSize: isLarge ? 16 : 13,
              fontWeight: FontWeight.w600,
              color: isLarge ? Colors.white : AppColors.primary600,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.add,
            size: isLarge ? 20 : 16,
            color: isLarge ? Colors.white : AppColors.primary600,
          ),
        ],
      ),
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double totalRemaining;
  final double progress;

  const _BudgetSummaryCard({
    required this.totalBudget,
    required this.totalSpent,
    required this.totalRemaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF4338CA),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4338CA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'December 2023', // TODO: Make dynamic date
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monthly Budget',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% Used',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.watch<CurrencyProvider>().currency.symbol}${totalSpent.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'of ${context.watch<CurrencyProvider>().currency.symbol}${totalBudget.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Spent this month',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress Bar
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Remaining: ',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                '${context.watch<CurrencyProvider>().currency.symbol}${totalRemaining.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
