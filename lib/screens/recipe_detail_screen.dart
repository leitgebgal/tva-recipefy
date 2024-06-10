import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:recipefy/models/recipe.dart';
import 'package:recipefy/screens/edit_recipe_screen.dart';
import 'package:recipefy/services/firebase_service.dart';
import 'package:recipefy/theme/app_theme.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final FirebaseService firebaseService = FirebaseService();
  late Recipe recipe;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    final snapshot = await firebaseService.getDocument('recipes', widget.recipeId);

    if (snapshot.exists) {
      setState(() {
        recipe = Recipe.fromJson(snapshot.data() as Map<String, dynamic>);
        currentUser = firebaseService.getCurrentUser();
      });
    }
  }

  Future<void> _rateRecipe(int rating) async {
    final currentUserEmail = firebaseService.getCurrentUser()?.email;
    if (currentUserEmail != null) {
      final newRating = Rating(value: rating, ratedBy: currentUserEmail);
      final updatedRatings = [...recipe.ratings!, newRating];
      final updatedRecipe = recipe.copyWith(ratings: updatedRatings);
      try {
        await firebaseService.updateDocument('recipes', widget.recipeId, updatedRecipe.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe rated successfully'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to rate recipe. Please try again later.'), backgroundColor: Colors.red),
      );
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: firebaseService.getDocument('recipes', widget.recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading recipe'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Recipe not found'));
          }

          final recipe = Recipe.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PhotoViewGalleryWrapper(
                              imageProvider: NetworkImage(recipe.image ?? ''),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        child: Image.network(
                          recipe.image ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Wrap(
                                spacing: 8.0,
                                children: recipe.categories?.map((category) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      category.toString(),
                                      style: const TextStyle(
                                        color: AppTheme.whiteColorAlt,
                                      ),
                                    ),
                                  );
                                }).toList() ?? [],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ingredients:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...recipe.ingredients?.map((ingredient) {
                            return Text(
                              '- ${ingredient.name ?? ''}: ${ingredient.value ?? ''} ${ingredient.unit ?? ''}',
                              style: const TextStyle(fontSize: 16),
                            );
                          }).toList() ?? [],
                          const SizedBox(height: 16),
                          const Text(
                            'Instructions:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...?recipe.instructions?.split('.').map((sentence) {
                            if (sentence.trim().isEmpty) return Container();
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                sentence.trim() + '.',
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                          if (recipe.owner != null) ...[
                            const Text(
                              'Recipe by:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe.owner!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                           const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Rate Recipe'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Rate this recipe from 1 to 5:'),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (int i = 1; i <= 5; i++)
                                                ElevatedButton(
                                                  onPressed: () => _rateRecipe(i),
                                                  style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    minimumSize: const Size(36, 36),
                                                  ),
                                                  child: Text(i.toString()),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Rate Recipe'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (currentUser != null && currentUser?.email == recipe.owner)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Recipe'),
                                    content: const Text('Are you sure you want to delete this recipe?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try{
                                            await firebaseService.deleteDocument('recipes', widget.recipeId);
                                            Navigator.of(context).pushReplacementNamed('/home');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Successfully deleted recipe!'), backgroundColor: Colors.green),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Failed to delete recipe. Please try again later.'), backgroundColor: Colors.red),
                                            );
                                          }
                                          
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red
                                        ),
                                        child: const Text('Confirm', style: TextStyle(color: AppTheme.whiteColorAlt)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Delete Recipe', style: TextStyle(color: AppTheme.whiteColorAlt)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRecipeScreen(recipeId: widget.recipeId),
                                ),
                              );
                            },
                            child: const Text('Edit Recipe'),
                          ),
                        ),
                        ],
                      ),
                      const SizedBox(height: 16), 
                  ],
                ),
              ),
              Positioned(
                top: 40.0,
                left: 16.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PhotoViewGalleryWrapper extends StatelessWidget {
  final ImageProvider imageProvider;
  const PhotoViewGalleryWrapper({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: const BoxDecoration(
          color: AppTheme.blackColor,
        ),
      ),
    );
  }
}