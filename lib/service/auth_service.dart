import 'package:http/http.dart' as http;

// À compléter avec la logique d'appel HTTP (package 'http' ou 'dio')
class AuthService {
  // TODO: Définir l'URL de base de votre API [cite: 34]
  final String _baseUrl = 'http://votre-api.com/api/v1';

  /// Tente de connecter l'utilisateur et retourne le token JWT en cas de succès.
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'), // Endpoint API de connexion [cite: 26]
      body: {'email': email, 'password': password},
      // Headers pour JSON si nécessaire
    );

    if (response.statusCode == 200) {
      // TODO: Parser la réponse pour extraire le Token (JWT)
      // return jsonDecode(response.body)['token'];
      return 'fake-jwt-token';
    } else {
      // Gérer les erreurs (identifiants invalides, etc.)
      return null;
    }
  }

  /// Tente de créer un nouveau compte.
  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'), // Endpoint API de création de compte [cite: 26]
      body: {'email': email, 'password': password},
    );

    return response.statusCode == 201; // 201 Created
  }

// TODO: Ajouter des méthodes pour la déconnexion, le stockage/récupération du JWT, etc.
}