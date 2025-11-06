import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../service/auth_service.dart'; // Import du service pour la connexion
import 'create_account_screen.dart'; // Import de l'écran de destination


//A voir
import 'MenuPage.dart'; // Import de l'écran d'accueil (pour la navigation après succès)


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implémenter la logique de connexion (email/mot de passe minimum)
      final authService = AuthService();
      final String? token = await authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (token != null) { // Si un token est reçu, la connexion est réussie
        print('Connexion réussie: Naviguer vers l\'écran d\'accueil');

        // TODO: Naviguer vers l'écran d'accueil ou de menu
        // Utilisation de pushReplacement pour empêcher le retour à l'écran de connexion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      } else {
        // Afficher une erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de la connexion. Email ou mot de passe incorrect.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Se connecter'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Bienvenue ! Connectez-vous pour gérer vos réservations.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Champ Email
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ Mot de passe
              CustomTextField(
                controller: _passwordController,
                labelText: 'Mot de passe',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bouton de connexion
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Se connecter',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Lien vers l'inscription
              TextButton(
                onPressed: () {
                  // Navigation vers la page de création de compte
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
                  );
                },
                child: const Text("Pas encore de compte ? Créer un compte"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}