import 'package:flutter/material.dart';
import 'package:recipefy/models/recipe.dart';
import 'package:recipefy/screens/recipe_detail_screen.dart';
import 'package:recipefy/services/firebase_service.dart';
import 'package:recipefy/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    _firebaseService.getCollection('recipes').listen((event) {
      setState(() {
        _recipes = event.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null ? Recipe.fromJson(data, id: doc.id) : Recipe();
        }).toList();
        _filteredRecipes = _recipes;
      });
    });
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query == "") {
        _filteredRecipes = _recipes;
      } else {
        _filteredRecipes = _recipes.where((recipe) {
          final categories = recipe.categories?.map((cat) => cat.toString().toLowerCase()).toList() ?? [];
          final title = recipe.title?.toLowerCase() ?? '';
          return title.contains(query) || categories.any((cat) => cat.contains(query));
        }).toList();
      }
    });
  }

  double _calculateAverageRating(List<Rating>? ratings) {
    if (ratings == null || ratings.isEmpty) {
      return 0.0;
    }
    final total = ratings.fold(0, (sum, rating) => sum + (rating.value ?? 0));
    return total / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 250).floor();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredRecipes.length,
                itemBuilder: (context, index) {
                  return _buildRecipeCard(_filteredRecipes[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search recipes by title or category',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final averageRating = _calculateAverageRating(recipe.ratings);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipeId: recipe.id!),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                recipe.image ?? '',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          recipe.title ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 16),
                        Wrap(
                          spacing: 4.0,
                          children: recipe.categories?.map((category) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                category.toString(),
                                style: const TextStyle(
                                  color: AppTheme.whiteColorAlt,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }).toList() ?? [],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < averageRating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: const Color.fromARGB(255, 212, 193, 18),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
