// Fichier : lib/screen/menu_page.dart

import 'package:flutter/material.dart';
import '../model/dish.dart';
import '../widgets/dish_card.dart';
import '../service/dish_service.dart'; // NOUVEL IMPORT

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});
  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Liste des catégories (elles doivent correspondre aux valeurs de 'type_nom' de votre BDD)
  final List<String> categories = [
    'Formules',
    'Entrée',
    'Plat',
    'Dessert',
    'Boisson froide',
  ];

  String selectedCategory = 'Formules';

  // États pour les données et le chargement
  List<Dish> _allDishes = [];
  bool _isLoading = true;
  final DishService _dishService = DishService();

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async {
    try {
      // Démarre le chargement
      setState(() {
        _isLoading = true;
      });

      // Appel au service pour récupérer les plats du restaurant ID 1
      final fetchedDishes = await _dishService.fetchDishes(1);

      setState(() {
        _allDishes = fetchedDishes;
        _isLoading = false;

        // S'assurer que la catégorie sélectionnée est valide si des plats ont été chargés
        if (_allDishes.isNotEmpty && !_allDishes.any((d) => d.category == selectedCategory)) {
          selectedCategory = _allDishes.first.category;
        }
      });
    } catch (e) {
      print('Erreur lors du chargement du menu: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de charger le menu depuis l'API.")),
      );
    }
  }

  // Getter pour filtrer les plats en fonction de la catégorie sélectionnée
  List<Dish> get _dishesForSelectedCategory {
    return _allDishes
        .where((dish) => dish.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Affichage du loader ou du contenu
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Nos Catégories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Ligne de Catégories
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            // Affiche un message si la liste est vide après chargement
            child: _dishesForSelectedCategory.isEmpty
                ? const Center(child: Text("Aucun plat disponible dans cette catégorie."))
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _dishesForSelectedCategory.length,
              itemBuilder: (context, index) {
                final dish = _dishesForSelectedCategory[index];
                return DishCard(dish: dish);
              },
            ),
          ),
        ],
      ),
    );
  }
}