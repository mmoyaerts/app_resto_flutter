import 'package:http/http.dart' as http;

// À compléter avec la logique d'appel HTTP (package 'http' ou 'dio')
class AuthService {
  // TODO: Définir l'URL de base de votre API [cite: 34]
  final String _baseUrl = 'http://localhost:3000/api';

  /// Tente de connecter l'utilisateur et retourne le token JWT en cas de succès.
  Future<String?> login(String email, String password) async {
    if (email == 'toto@gmail.com' && password == '1234') {
      return 'fake-jwt-token'; // token fictif
    }
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return 'fake-jwt-token';
    } else {
      // Gérer les erreurs
      return null;
    }
  }

  /// Tente de créer un nouveau compte.
  Future<bool> register(String nom, String email, String password, int role) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      body: {'nom': nom, 'email': email, 'password': password, 'role': role},
    );

    return response.statusCode == 201;
  }
}