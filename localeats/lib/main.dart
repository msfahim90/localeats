import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDnauqzNCh8NQL_B-FK6lXI24cnu2foRes",
      authDomain: "localeats-e3b2e.firebaseapp.com",
      projectId: "localeats-e3b2e",
      storageBucket: "localeats-e3b2e.firebasestorage.app",
      messagingSenderId: "236112598717",
      appId: "1:236112598717:web:5fb5bb1a977f67e125c9d4",
    ),
  );
  runApp(const LocalEatsApp());
}

class LocalEatsApp extends StatelessWidget {
  const LocalEatsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (_, theme, __) => MaterialApp(
          title: 'LocalEats',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
