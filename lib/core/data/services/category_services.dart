import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  CategoryService({required this.userId});

  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference get _categoriesRef => _usersRef.doc(userId).collection('categories');

  // Stream of categories
  Stream<List<CategoryModel>> getCategories() {
    return _categoriesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();
    });
  }

  // Add a new category
  Future<void> addCategory(CategoryModel category) async {
    await _categoriesRef.doc(category.id).set(category.toFirestore());
  }

  // Update a category
  Future<void> updateCategory(CategoryModel category) async {
    await _categoriesRef.doc(category.id).update(category.toFirestore());
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    await _categoriesRef.doc(categoryId).delete();
  }

  // Seed default categories if none exist
  Future<void> seedDefaultCategories() async {
    try {
      final snapshot = await _categoriesRef.limit(1).get();
      if (snapshot.docs.isNotEmpty) return;

      final defaultCategories = [
        // Expenses
        CategoryModel(
            id: _categoriesRef.doc().id,
            name: 'Food & Dining',
            type: 'expense',
            iconCode: 57902, // Icons.restaurant
            colorValue: 0xFFFFA726, // Colors.orange
            isDefault: true,
            userId: userId
        ),
        CategoryModel(
            id: _categoriesRef.doc().id,
            name: 'Transport',
            type: 'expense',
            iconCode: 57683, // Icons.directions_car
            colorValue: 0xFF42A5F5, // Colors.blue
            isDefault: true,
            userId: userId
        ),
        CategoryModel(
            id: _categoriesRef.doc().id,
            name: 'Utilities',
            type: 'expense',
            iconCode: 58249, // Icons.lightbulb
            colorValue: 0xFFFFEE58, // Colors.yellow
            isDefault: true,
            userId: userId
        ),
        CategoryModel(
            id: _categoriesRef.doc().id,
            name: 'Shopping',
            type: 'expense',
            iconCode: 59073, // Icons.shopping_bag
            colorValue: 0xFFEC407A, // Colors.pink
            isDefault: true,
            userId: userId
        ),

        // Income
        CategoryModel(
            id: _categoriesRef.doc().id,
            name: 'Salary',
            type: 'income',
            iconCode: 59641, // Icons.work
            colorValue: 0xFF66BB6A, // Colors.green
            isDefault: true,
            userId: userId
        ),
        CategoryModel(
            id: _categoriesRef.doc().id,
            name: 'Freelance',
            type: 'income',
            iconCode: 57674, // Icons.computer
            colorValue: 0xFFAB47BC, // Colors.purple
            isDefault: true,
            userId: userId
        ),
      ];

      final batch = _firestore.batch();
      for (var cat in defaultCategories) {
        final docRef = _categoriesRef.doc(cat.id);
        batch.set(docRef, cat.toFirestore());
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Error seeding categories: $e");
    }
  }
}
