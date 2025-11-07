import 'dart:convert';

import 'package:http/http.dart' as http;

// À compléter avec la logique d'appel HTTP (package 'http' ou 'dio')
class AuthService {
  final String _baseUrl = 'http://127.0.0.1:3000/api/auth';

  /// Tente de connecter l'utilisateur et retourne le token JWT en cas de succès.
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final utilisateur = data['utilisateur'];

      return {
        'token': data['token'] as String,
        'role': int.tryParse(utilisateur['role_id'].toString()),
        'id': int.tryParse(utilisateur['id'].toString()),
      };
    }

    return null;
  }

  /// Tente de créer un nouveau compte.
  Future<http.Response> register(String nom, String email, String password, int role) async {
    final url = Uri.parse('$_baseUrl/register');

    final body = jsonEncode({
      'nom': nom,
      'email': email,
      'password': password,
      'role_id': role,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }
}