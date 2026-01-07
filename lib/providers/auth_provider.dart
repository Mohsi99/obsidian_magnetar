import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/data/services/auth_services.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = false;

  AppAuthProvider({required AuthService authService}) : _authService = authService {
    // Listen to auth state changes from the service
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmail(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpWithEmail(email: email, password: password, fullName: fullName);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
