import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/data/model/budget_model.dart';
import '../core/data/services/budget_services.dart';


class BudgetProvider extends ChangeNotifier {
  BudgetService? _budgetService;
  List<BudgetModel> _budgets = [];
  bool _isLoading = false;

  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;

  void updateUser(User? user) {
    debugPrint("BudgetProvider: updateUser called with ${user?.uid}");
    if (user != null) {
      if (_budgetService?.userId != user.uid) {
        debugPrint("BudgetProvider: initializing BudgetService for ${user.uid}");
        _budgetService = BudgetService(userId: user.uid);
        _fetchBudgets();
      }
    } else {
      debugPrint("BudgetProvider: User is null, clearing service");
      _budgetService = null;
      _budgets = [];
      notifyListeners();
    }
  }

  Future<void> _fetchBudgets() async {
    if (_budgetService == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _budgetService!.getBudgets().listen((budgetList) {
        _budgets = budgetList;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        debugPrint('Error in budget stream: $error');
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error fetching budgets: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBudget(BudgetModel budget) async {
    if (_budgetService == null) {
      debugPrint("BudgetProvider: Error - BudgetService is NULL. Cannot add budget.");
      return;
    }
    try {
      debugPrint("BudgetProvider: Adding budget for category ${budget.categoryId}");
      await _budgetService!.addBudget(budget);
    } catch (e) {
      debugPrint('Error adding budget: $e');
      rethrow;
    }
  }

  Future<void> updateBudget(BudgetModel budget) async {
    if (_budgetService == null) return;
    try {
      await _budgetService!.updateBudget(budget);
    } catch (e) {
      debugPrint('Error updating budget: $e');
      rethrow;
    }
  }

  Future<void> updateSpent(String budgetId, double amount) async {
    if (_budgetService == null) return;
    try {
      await _budgetService!.updateBudgetSpent(budgetId, amount);
      // Optimistically update local state or re-fetch?
      // Since we are using streams, the stream listener should update the state.
      // But we can also update locally for immediate UI feedback if needed.
    } catch (e) {
      debugPrint('Error updating budget spent: $e');
      rethrow;
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    if (_budgetService == null) return;
    try {
      await _budgetService!.deleteBudget(budgetId);
    } catch (e) {
      debugPrint('Error deleting budget: $e');
      rethrow;
    }
  }
}
