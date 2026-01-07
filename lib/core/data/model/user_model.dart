import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String? photoURL;
  final String currency;
  final String startOfWeek;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.currency = 'USD',
    this.startOfWeek = 'Monday',
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      currency: data['currency'] ?? 'USD',
      startOfWeek: data['startOfWeek'] ?? 'Monday',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'currency': currency,
      'startOfWeek': startOfWeek,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoURL,
    String? currency,
    String? startOfWeek,
  }) {
    return UserModel(
      userId: userId,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      currency: currency ?? this.currency,
      startOfWeek: startOfWeek ?? this.startOfWeek,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
