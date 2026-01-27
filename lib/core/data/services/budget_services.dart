import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/budget_model.dart';


class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  BudgetService({required this.userId});

  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference get _budgetsRef {
    final path = _usersRef.doc(userId).collection('budgets');
    debugPrint("BudgetService: Accessing collection at path: ${path.path}");
    return path;
  }

  // Stream of budgets
  Stream<List<BudgetModel>> getBudgets() {
    return _budgetsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BudgetModel.fromFirestore(doc)).toList();
    });
  }

  // Add a new budget
  Future<void> addBudget(BudgetModel budget) async {
    await _budgetsRef.doc(budget.id.isEmpty ? null : budget.id).set(budget.toFirestore());
  }

  // Update a budget
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _budgetsRef.doc(budget.id).update(budget.toFirestore());
    } catch (e) {
      debugPrint('Error updating budget: $e');
      rethrow;
    }
  }

  Future<void> updateBudgetSpent(String budgetId, double amount) async {
    try {
      await _budgetsRef.doc(budgetId).update({
        'spent': FieldValue.increment(amount),
      });
    } catch (e) {
      debugPrint('Error updating budget spent amount: $e');
      rethrow;
    }
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    await _budgetsRef.doc(budgetId).delete();
  }
}
