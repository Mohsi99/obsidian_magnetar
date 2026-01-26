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

  void updateUser(User? user) {
    debugPrint("CategoryProvider: updateUser called with ${user?.uid}");
    if (user != null) {
      if (_categoryService?.userId != user.uid) {
        debugPrint(
            "CategoryProvider: initializing CategoryService for ${user.uid}");
        _categoryService = CategoryService(userId: user.uid);
        _fetchCategories();
      }
    } else {
      debugPrint("CategoryProvider: User is null, clearing service");
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

  Future<void> addCategory(CategoryModel category) async {
    if (_categoryService == null) {
      debugPrint(
          "CategoryProvider: Error - CategoryService is NULL. Cannot add category.");
      return;
    }
    try {
      debugPrint("CategoryProvider: Adding category ${category.name}");
      await _categoryService!.addCategory(category);
      // The stream will automatically update the list
    } catch (e) {
      debugPrint('Error adding category: $e');
      rethrow;
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    if (_categoryService == null) return;
    try {
      await _categoryService!.updateCategory(category);
    } catch (e) {
      debugPrint('Error updating category: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    if (_categoryService == null) return;
    try {
      await _categoryService!.deleteCategory(categoryId);
    } catch (e) {
      debugPrint('Error deleting category: $e');
      rethrow;
    }
  }
}