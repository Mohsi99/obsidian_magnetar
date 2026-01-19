import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String type;
  final bool isDefault;
  final int iconCode;
  final int colorValue;
  final String userId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.colorValue,
    this.isDefault = false,
    required this.userId,
  });

  // Factory to map from Firestore
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'expense',
      iconCode: data['iconCode'] ?? 58840,
      colorValue: data['colorValue'] ?? 0xFF9E9E9E,
      isDefault: data['isDefault'] ?? false,
      userId: data['userId'] ?? '',
    );
  }

  // Map to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'iconCode': iconCode,
      'colorValue': colorValue,
      'isDefault': isDefault,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
