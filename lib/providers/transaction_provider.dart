import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:obsidian_magnetar/core/data/model/transactions_model.dart';
import 'package:obsidian_magnetar/core/data/services/transaction_service.dart';

import '../core/data/model/budget_model.dart';
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
      _transactions = [];
      notifyListeners();
    }
  }

  Future<void> _fetchTransactions() async {
    if (_transactionService == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      _transactionService!.getTransactions().listen((transactionsList) {
        _transactions = transactionsList;
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

    if (transaction.amount > budget.remaining) {
      throw Exception('Transaction amount exceeds budget remaining amount.');
    }

    try {
      await _transactionService!.addTransaction(transaction);
      await budgetProvider.updateSpent(budget.id, transaction.amount);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
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
      // Inverse the spent amount
      await budgetProvider.updateSpent(budgetId, -amount);
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }
}
