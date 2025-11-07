// Fichier : lib/model/dish.dart

class Dish {
  final String name;
  final String description;
  final double price;
  final String image;
  // Ajout de la catégorie (type_nom dans le backend) pour le filtrage
  final String category;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  // Factory pour créer un objet Dish à partir d'une réponse JSON de l'API
  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      // Les noms des champs JSON sont basés sur votre requête SQL dans plat.js
      name: json['nom'] as String,
      description: json['description'] as String,
      // Utilise num pour gérer si le prix est un int ou un double dans le JSON
      price: (json['prix'] as num).toDouble(),
      image: json['image'] as String? ?? '', // Gérer les images potentiellement nulles ou manquantes
      category: json['type_nom'] as String, // 'type_nom' vient de la jointure SQL sur type_plats
    );
  }
}