import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  final AuthService _authService = AuthService();

  /// Connexion
  Future<bool> login(String email, String password) async {
    final token = await _authService.login(email, password);
    if (token != null) {
      _token = token;
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Déconnexion
  void logout() {
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
