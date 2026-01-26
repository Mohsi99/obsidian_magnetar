import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/core/data/model/budget_model.dart';

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

  Stream<List<BudgetModel>> getBudgets() {
    return _budgetsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addBudget(BudgetModel budget) async {
    await _budgetsRef
        .doc(budget.id.isEmpty ? null : budget.id)
        .set(budget.toFirestore());
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _budgetsRef.doc(budget.id).update(budget.toFirestore());
  }

  Future<void> deleteBudget(String budgetId) async {
    await _budgetsRef.doc(budgetId).delete();
  }
}
