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
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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

