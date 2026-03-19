import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const LocalEatsApp());
}

class LocalEatsApp extends StatelessWidget {
  const LocalEatsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
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
