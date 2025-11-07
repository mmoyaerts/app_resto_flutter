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
    double parsedPrice = 0.0;

    if (json['prix'] != null) {
      if (json['prix'] is String) {
        parsedPrice = double.tryParse(json['prix']) ?? 0.0;
      } else if (json['prix'] is num) {
        parsedPrice = json['prix'].toDouble();
      }
    }

    return Dish(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: parsedPrice,
      image: json['image'] ?? '',
      category: json['type_nom'] ?? '',
    );
  }
}