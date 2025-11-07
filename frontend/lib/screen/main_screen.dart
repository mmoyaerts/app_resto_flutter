import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'menu_page.dart';
import 'reservation_page.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'liste_reservation_page.dart';


class MainScreen extends StatefulWidget {
  final String title;

  const MainScreen({super.key, required this.title});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Liste dynamique selon auth.id
    final List<Widget> screens = [
      const MenuPage(title: 'Menu du petit cochon'),
      (auth.role == 2)
          ? const ListeReservationPage(restaurantId: 1)
          : const ReservationPage(),
      const LoginScreen(),
    ];

    return Scaffold(
      appBar: buildAppBar(context, widget.title),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context, String title) {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  return AppBar(
    title: Text(title),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        tooltip: 'Déconnexion',
        onPressed: () {
          // Appel de la méthode de déconnexion dans le provider
          auth.logout();

          // Affiche un message SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous êtes déconnecté')),
          );

          // Optionnel : redirige vers la page de connexion
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    ],
  );
}

