import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../core/data/model/user_model.dart';
import '../core/data/services/auth_services.dart';


class UserProvider extends ChangeNotifier {
  final AuthService _authService;
  UserModel? _userModel;

  UserProvider({required AuthService authService})
      : _authService = authService {
    _authService.userChanges.listen(_onAuthStateChanged);
  }

  UserModel? get userModel => _userModel;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      try {
        await firebaseUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        _userModel = UserModel(
          userId: refreshedUser?.uid ?? firebaseUser.uid,
          email: refreshedUser?.email ?? '',
          displayName: refreshedUser?.displayName ?? 'User',
          photoURL: refreshedUser?.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } catch (e) {
        _userModel = UserModel(
          userId: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          photoURL: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } else {
      _userModel = null;
    }
    notifyListeners();
  }
}
