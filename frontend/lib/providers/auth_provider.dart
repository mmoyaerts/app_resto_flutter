import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  int? _role;
  int? _id;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  int? get role => _role;
  int? get id => _id;

  final AuthService _authService = AuthService();

  /// Connexion
  Future<bool> login(String email, String password) async {
    final response = await _authService.login(email, password);
    if (response != null) {
      _token = response['token'];
      _role = response['role'];
      _id = response['id'];
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
