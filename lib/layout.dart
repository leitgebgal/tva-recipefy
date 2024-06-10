import 'package:flutter/material.dart';
import 'package:recipefy/theme/app_theme.dart';

import 'screens/add_recipe_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'main.dart';

class Layout extends StatefulWidget {
  final Widget child;
  final int index;

  const Layout({super.key, required this.child, required this.index});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const AddRecipeScreen()
  ];

  void _onTabTapped(int index) {
    if (widget.index != index) {
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => Layout(index: index, child: _screens[index])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.primaryColorAlt,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Recipe',
          )
        ],
        currentIndex: widget.index,
        selectedItemColor: AppTheme.whiteColorAlt,
        unselectedItemColor: AppTheme.greyColor,
        onTap: _onTabTapped,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedIconTheme: const IconThemeData(size: 24.0),
        unselectedIconTheme: const IconThemeData(size: 24.0),
        type: BottomNavigationBarType.fixed, // Ensures all items are displayed with equal width
      ),
    );
  }
}