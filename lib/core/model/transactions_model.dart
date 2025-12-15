
enum TransactionType { income, expense }

class TransactionModel {
  final String transactionId;
  final String userId;
  final TransactionType type;
  final double amount;
  final String category;
  final String categoryId;
  final DateTime date;
  final String? note;
  final bool isRecurring;
  final RecurringPattern? recurringPattern;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.categoryId,
    required this.date,
    this.note,
    this.isRecurring = false,
    this.recurringPattern,
    required this.createdAt,
    required this.updatedAt,
  });

// Removed Firestore specific methods for UI-only implementation
}

class RecurringPattern {
  final String frequency; // daily, weekly, monthly
  final int interval;
  final DateTime? endDate;

  RecurringPattern({
    required this.frequency,
    required this.interval,
    this.endDate,
  });
}
