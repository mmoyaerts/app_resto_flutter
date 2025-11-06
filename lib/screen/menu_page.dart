import 'package:flutter/material.dart';
import '../model/dish.dart';
import '../widgets/dish_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});
  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> categories = [
    'Formules',
    'Entrées',
    'Plats',
    'Desserts',
    'Boissons',
  ];

  String selectedCategory = 'Formules';

  final Map<String, List<Dish>> dishesByCategory = {
    'Formules': [
      Dish(
        name: 'Menu du Chef',
        description: 'Entrée + Plat + Dessert + Boisson',
        price: 25.0,
        image: 'assets/images/formule1.jpg',
      ),
      Dish(
        name: 'Formule Express',
        description: 'Plat + Boisson',
        price: 12.0,
        image: 'assets/images/formule2.jpg',
      ),
    ],
    'Entrées': [
      Dish(
        name: 'Salade César',
        description: 'Laitue, poulet, croûtons, parmesan',
        price: 8.0,
        image: 'assets/images/salade-cesar.webp',
      ),
      Dish(
        name: 'Soupe du jour',
        description: 'Préparée avec les légumes frais du marché',
        price: 6.5,
        image: 'assets/images/soupejpg.jpg',
      ),
    ],
    'Plats': [
      Dish(
        name: 'Steak Frites',
        description: 'Steak grillé avec frites maison',
        price: 15.0,
        image: 'assets/images/steakfrite.jpg',
      ),
      Dish(
        name: 'Pâtes Carbonara',
        description: 'Pâtes avec sauce crémeuse, lardons et parmesan',
        price: 13.0,
        image: 'assets/images/patecarbo.webp',
      ),
    ],
    'Desserts': [
      Dish(
        name: 'Tiramisu',
        description: 'Dessert italien classique',
        price: 6.0,
        image: 'assets/images/tiramisu.jpg',
      ),
      Dish(
        name: 'Crème brûlée',
        description: 'Dessert vanillé avec caramel croquant',
        price: 6.5,
        image: 'assets/images/cremebrulee.webp',
      ),
    ],
    'Boissons': [
      Dish(
        name: 'Coca-Cola',
        description: 'Boisson gazeuse rafraîchissante',
        price: 3.0,
        image: 'assets/images/COCA-33cl.webp',
      ),
      Dish(
        name: 'Jus d’orange',
        description: 'Pressé frais',
        price: 3.5,
        image: 'assets/images/jusdorange.png',
      ),
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
          // Catégories horizontales
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                bool isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
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
          // Liste des plats
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: dishesByCategory[selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final dish = dishesByCategory[selectedCategory]![index];
                return DishCard(dish: dish);
              },
            ),
          ),
        ],
      ),
    );
  }
}
