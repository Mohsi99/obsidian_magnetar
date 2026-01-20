import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  CategoryService({required this.userId});

  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference get _categoriesRef {
    final path = _usersRef.doc(userId).collection('categories');
    debugPrint("CategoryService: Accessing collection at path: ${path.path}");
    return path;
  }

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
}
