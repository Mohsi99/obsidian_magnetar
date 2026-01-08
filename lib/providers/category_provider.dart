import 'package:flutter/material.dart';

import '../core/data/model/category_model.dart';
import '../core/data/services/category_services.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService;

  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  CategoryProvider({required CategoryService categoryService})
      : _categoryService = categoryService;

  List<CategoryModel> get categories => _categories;

  bool get isLoading => _isLoading;

  Stream<List<CategoryModel>> getCategoriesStream(String userId) {
    return _categoryService.getCategories(userId);
  }

  Future<void> addCategory(CategoryModel category) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryService.addCategory(category);
    } catch (e) {
      debugPrint("Error adding category: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryService.updateCategory(category);
    } catch (e) {
      debugPrint("Error updating category: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String userId, String categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryService.deleteCategory(userId, categoryId);
    } catch (e) {
      debugPrint("Error deleting category: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
