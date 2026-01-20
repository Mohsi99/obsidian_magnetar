import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int iconCode;
  final int colorValue;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
  });

  // Factory to map from Firestore
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      iconCode: data['iconCode'] ?? 58840, // Default to a generic icon (e.g., Icons.category) code point
      colorValue: data['colorValue'] ?? 0xFF9E9E9E, // Default to Grey
    );
  }

  // Map to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconCode': iconCode,
      'colorValue': colorValue,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
