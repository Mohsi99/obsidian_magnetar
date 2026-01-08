import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obsidian_magnetar/core/data/model/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _getCategoryCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('categories');
  }

  Stream<List<CategoryModel>> getCategories(String userId) {
    return _getCategoryCollection(userId)
        .orderBy("createdAt", descending: false)
        .snapshots()
        .map((snapshots) {
      return snapshots.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addCategory(CategoryModel category) async {
    await _getCategoryCollection(category.userId).add(category.toFirestore());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _getCategoryCollection(category.userId)
        .doc(category.id)
        .update(category.toFirestore());
  }

  Future<void> deleteCategory(String userId, String categoryId) async {
    await _getCategoryCollection(userId).doc(categoryId).delete();
  }
}
