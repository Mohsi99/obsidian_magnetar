import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/data/model/budget_model.dart';
import '../core/data/model/transactions_model.dart';
import '../core/data/services/transaction_service.dart';

import 'budget_provider.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionService? _transactionService;
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  void updateUser(User? user) {
    if (user != null) {
      if (_transactionService?.userId != user.uid) {
        _transactionService = TransactionService(userId: user.uid);
        _fetchTransactions();
      }
    } else {
      _transactionService = null;
      _transactions = [];
      notifyListeners();
    }
  }

  Future<void> _fetchTransactions() async {
    if (_transactionService == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _transactionService!.getTransactions().listen((transactionList) {
        _transactions = transactionList;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        debugPrint('Error in transaction stream: $error');
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(
      TransactionModel transaction,
      BudgetProvider budgetProvider,
      BudgetModel budget,
      ) async {
    if (_transactionService == null) return;

    // Check budget limits
    // Note: The UI should handle displaying the error dialog based on this check or similar logic.
    // However, if we want to enforce it here:
    if (transaction.amount > budget.remaining) {
      throw Exception('Transaction amount exceeds budget remaining amount.');
    }

    try {
      await _transactionService!.addTransaction(transaction);
      // Update budget spent amount
      await budgetProvider.updateSpent(budget.id, transaction.amount);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(
      TransactionModel updatedTransaction,
      TransactionModel oldTransaction,
      BudgetProvider budgetProvider,
      BudgetModel currentBudget, // The budget currently selected in the UI
      ) async {
    if (_transactionService == null) return;

    // 1. Check if budget changed
    bool budgetChanged = updatedTransaction.budgetId != oldTransaction.budgetId;

    try {
      // 2. Update Firestore
      await _transactionService!.updateTransaction(updatedTransaction);

      // 3. Update Budgets
      if (budgetChanged) {
        // a. Refund the old budget
        // We need to find the old budget to update it.
        // Ideally we shouldn't rely on UI passing it if we can help it, but for now we rely on budgetProvider finding it or we just update via ID.
        // budgetProvider.updateSpent takes ID.
        await budgetProvider.updateSpent(oldTransaction.budgetId, -oldTransaction.amount);

        // b. Deduct from new budget
        await budgetProvider.updateSpent(updatedTransaction.budgetId, updatedTransaction.amount);
      } else {
        // Budget is the same, just update the difference
        double difference = updatedTransaction.amount - oldTransaction.amount;
        if (difference != 0) {
          await budgetProvider.updateSpent(updatedTransaction.budgetId, difference);
        }
      }

      // Update local list
      final index = _transactions.indexWhere((t) => t.id == updatedTransaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
        notifyListeners();
      }

    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(
      String transactionId,
      BudgetProvider budgetProvider,
      String budgetId,
      double amount,
      ) async {
    if (_transactionService == null) return;

    try {
      await _transactionService!.deleteTransaction(transactionId);
      // Inverse the spent amount (refund)
      await budgetProvider.updateSpent(budgetId, -amount);

      _transactions.removeWhere((t) => t.id == transactionId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }
}
