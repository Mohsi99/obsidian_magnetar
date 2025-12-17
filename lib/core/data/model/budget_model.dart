
class BudgetModel {
  final String budgetId;
  final String userId;
  final String categoryId;
  final double amount;
  final String period;
  final String month;
  final double spent;
  final double remaining;
  final List<int> alertThresholds;
  final List<int> alertsSent;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    required this.budgetId,
    required this.userId,
    required this.categoryId,
    required this.amount,
    this.period = 'monthly',
    required this.month,
    this.spent = 0,
    double? remaining,
    this.alertThresholds = const [50, 75, 100],
    this.alertsSent = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : remaining = remaining ?? (amount - spent);

  double get percentage => amount > 0 ? (spent / amount * 100).clamp(0, 100) : 0;

  BudgetModel copyWith({
    double? spent,
    List<int>? alertsSent,
  }) {
    return BudgetModel(
      budgetId: budgetId,
      userId: userId,
      categoryId: categoryId,
      amount: amount,
      period: period,
      month: month,
      spent: spent ?? this.spent,
      alertThresholds: alertThresholds,
      alertsSent: alertsSent ?? this.alertsSent,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
