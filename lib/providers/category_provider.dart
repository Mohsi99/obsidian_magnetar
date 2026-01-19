import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/data/model/category_model.dart';
import '../core/data/services/category_services.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryService? _categoryService;
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  List<CategoryModel> get expenseCategories =>
      _categories.where((c) => c.type == 'expense').toList();

  List<CategoryModel> get incomeCategories =>
      _categories.where((c) => c.type == 'income').toList();

  void updateUser(User? user) {
    if (user != null) {
      if (_categoryService?.userId != user.uid) {
        _categoryService = CategoryService(userId: user.uid);
        _fetchCategories();
      }
    } else {
      _categoryService = null;
      _categories = [];
      notifyListeners();
    }
  }

  Future<void> _fetchCategories() async {
    if (_categoryService == null) return;

    _isLoading = true;
    notifyListeners(); // Notify loading start

    try {
      // First ensure default categories exist
      await _categoryService!.seedDefaultCategories();

      // Then listen to the stream
      _categoryService!.getCategories().listen((categoryList) {
        _categories = categoryList;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        debugPrint('Error in category stream: $error');
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
}
