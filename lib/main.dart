import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipefy/screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'layout.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // GLOBAL

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipefy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        // Define routes using path keys
        final Map<String, WidgetBuilder> routes = {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/home': (context) => const Layout(index: 0, child: HomeScreen()),
          '/add': (context) => const Layout(index: 1, child: AddRecipeScreen()),
          '/splash': (context) => const SplashScreen(),
          '/profile': (context) => const Layout(index: 2, child: ProfileScreen()),
        };

        // Get the builder function for the requested route
        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        } else {
          return null;
        }
      }
    );
  }
}