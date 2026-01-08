import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String type;
  final bool isDefault;
  final String userId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.isDefault = false,
    required this.userId,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'expense',
      isDefault: data['isDefault'] ?? false,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'isDefault': isDefault,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
