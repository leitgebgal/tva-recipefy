import 'package:flutter/material.dart';
import 'package:recipefy/theme/app_theme.dart';
import '../services/firebase_service.dart';
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _errorMessage = '';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _ingredientNameController = TextEditingController();
  final TextEditingController _ingredientUnitController = TextEditingController();
  final TextEditingController _ingredientValueController = TextEditingController();
  final List<Ingredient> _ingredients = [];

  Category _selectedCategory = Category.values.first;

  void _addIngredient() {
    setState(() {
      _ingredients.add(Ingredient(
        name: _ingredientNameController.text.trim(),
        unit: _ingredientUnitController.text.trim(),
        value: int.tryParse(_ingredientValueController.text.trim()) ?? 0,
      ));
      _ingredientNameController.clear();
      _ingredientUnitController.clear();
      _ingredientValueController.clear();
    });
  }

  Future<void> _addRecipe() async {
    final currentUser = _firebaseService.getCurrentUser();
    if (currentUser == null) {
      setState(() {
        _errorMessage = 'No user is signed in.';
      });
      return;
    }

    final recipe = Recipe(
      title: _titleController.text.trim(),
      instructions: _instructionsController.text.trim(),
      categories: [_selectedCategory.toString()],
      image: _imageController.text.trim(),
      owner: currentUser.email,
      ingredients: _ingredients,
      ratings: []
    );

    try {
      await _firebaseService.addDocument('recipes', recipe.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe added successfully'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add recipe. Please try again later.'), backgroundColor: Colors.red),
      );
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            'Add Recipe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _instructionsController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Instructions',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Category:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<Category>(
                value: _selectedCategory,
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: Category.values.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _imageController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: AppTheme.outlinedButtonStyle,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add Ingredient'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _ingredientNameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _ingredientUnitController,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _ingredientValueController,
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _addIngredient();
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Add Ingredient', style: TextStyle(color: AppTheme.whiteColorAlt)),
          ),
          const SizedBox(height: 20),
          if (_ingredients.isNotEmpty) ...[
            const Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _ingredients.asMap().entries.map((entry) {
                final index = entry.key;
                final ingredient = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '- ${ingredient.name ?? ''}: ${ingredient.value ?? ''} ${ingredient.unit ?? ''}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          _ingredients.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addRecipe,
              child: const Text('Add Recipe'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    ),
  );
}
}
