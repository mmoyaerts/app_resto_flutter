/// Modèle de données pour un Utilisateur.
class User {
  final String id;
  final String email;
  final String name;
  final String role;

  User({required this.id, required this.email, this.name = '', required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      role: json['role'] as String,
    );
  }
}