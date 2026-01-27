import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obsidian_magnetar/core/data/model/transactions_model.dart';

class TransactionService {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TransactionService({required this.userId});

  CollectionReference get _transactionsCollection =>
      _firestore.collection('users').doc(userId).collection('transactions');

  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _transactionsCollection.add(transaction.toFirestore());
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _transactionsCollection
          .doc(transaction.id)
          .update(transaction.toFirestore());
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }
}
