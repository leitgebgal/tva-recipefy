import 'package:flutter/material.dart';
import 'package:recipefy/theme/app_theme.dart';
import 'package:recipefy/services/firebase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _errorMessage = '';
  int _recipeCount = 0;
  double _averageRating = 0.0;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        setState(() {
          _email = user.email;
        });

        final recipes = await _firebaseService.getUserRecipes(user.email);
        final ratings = recipes
            .map((recipe) => recipe.ratings ?? [])
            .expand((rating) => rating)
            .toList();

        setState(() {
          _recipeCount = recipes.length;
          _averageRating = ratings.isNotEmpty
              ? ratings.map((rating) => rating.value!).reduce((a, b) => a + b) / ratings.length
              : 0.0;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _firebaseService.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _changePassword(String newPassword) async {
    try {
      await _firebaseService.changePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password successfully'), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _newPasswordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _signOut,
                      tooltip: 'Sign Out',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_email != null)
                  Text(
                    'Hi, $_email',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                const SizedBox(height: 20),
                TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _changePassword(_newPasswordController.text.trim());
                    _newPasswordController.clear();
                  },
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Recipes: $_recipeCount',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Average Rating: ${_averageRating.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
