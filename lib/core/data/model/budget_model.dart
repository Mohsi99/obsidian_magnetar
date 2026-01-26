import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String categoryId;
  final double amount;
  final double spent;
  final DateTime createdAt;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    this.spent = 0.0,
    required this.createdAt,
  });

  // Factory to map from Firestore
  factory BudgetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetModel(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      spent: (data['spent'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Map to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'amount': amount,
      'spent': spent,
      'createdAt': FieldValue.serverTimestamp(), // Use server timestamp
    };
  }

  BudgetModel copyWith({
    String? id,
    String? categoryId,
    double? amount,
    double? spent,
    DateTime? createdAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get remaining => amount - spent;
  double get percentage => amount == 0 ? 0 : (spent / amount) * 100;
}
