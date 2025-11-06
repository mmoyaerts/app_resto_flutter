import 'package:flutter/material.dart';

void main() {
  runApp(const RestaurantMenuApp());
}

/// Widget principal de l'application
class RestaurantMenuApp extends StatelessWidget {
  const RestaurantMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu du Restaurant X',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MenuPage(title: 'Menu du Restaurant X'),
    );
  }
}

/// Page principale affichant le menu
class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});
  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Liste des catégories
  final List<String> categories = [
    'Formules',
    'Entrées',
    'Plats',
    'Desserts',
    'Boissons',
  ];

  // Catégorie sélectionnée
  String selectedCategory = 'Formules';

  // Liste des plats codée en dur
  final Map<String, List<Dish>> dishesByCategory = {
    'Formules': [
      Dish(
          name: 'Menu du Chef',
          description: 'Entrée + Plat + Dessert + Boisson',
          price: 25.0,
          image: 'assets/images/formule1.jpg'),
      Dish(
          name: 'Formule Express',
          description: 'Plat + Boisson',
          price: 12.0,
          image: 'assets/images/formule2.jpg'),
    ],
    'Entrées': [
      Dish(
          name: 'Salade César',
          description: 'Laitue, poulet, croûtons, parmesan',
          price: 8.0,
          image: 'assets/images/salade-cesar.webp'),
      Dish(
          name: 'Soupe du jour',
          description: 'Préparée avec les légumes frais du marché',
          price: 6.5,
          image: 'assets/images/soupejpg.jpg'),
    ],
    'Plats': [
      Dish(
          name: 'Steak Frites',
          description: 'Steak grillé avec frites maison',
          price: 15.0,
          image: 'assets/images/steakfrite.jpg'),
      Dish(
          name: 'Pâtes Carbonara',
          description: 'Pâtes avec sauce crémeuse, lardons et parmesan',
          price: 13.0,
          image: 'assets/images/patecarbo.webp'),
    ],
    'Desserts': [
      Dish(
          name: 'Tiramisu',
          description: 'Dessert italien classique',
          price: 6.0,
          image: 'assets/images/tiramisu.jpg'),
      Dish(
          name: 'Crème brûlée',
          description: 'Dessert vanillé avec caramel croquant',
          price: 6.5,
          image: 'assets/images/cremebrulee.webp'),
    ],
    'Boissons': [
      Dish(
          name: 'Coca-Cola',
          description: 'Boisson gazeuse rafraîchissante',
          price: 3.0,
          image: 'assets/images/COCA-33cl.webp'),
      Dish(
          name: 'Jus d’orange',
          description: 'Pressé frais',
          price: 3.5,
          image: 'assets/images/jusdorange.png'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Zone catégories scrollable horizontalement
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                bool isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Liste verticale des plats pour la catégorie sélectionnée
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: dishesByCategory[selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                Dish dish = dishesByCategory[selectedCategory]![index];
                return DishCard(dish: dish);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Classe représentant un plat
class Dish {
  final String name;
  final String description;
  final double price;
  final String image;

  Dish(
      {required this.name,
        required this.description,
        required this.price,
        required this.image});
}

/// Widget réutilisable pour afficher une carte de plat
class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Image du plat
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                dish.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Informations sur le plat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dish.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${dish.price.toStringAsFixed(2)} €',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
