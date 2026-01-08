import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/auth.dart';
import 'pages/products_page.dart';
import 'pages/orders_page.dart';
import 'pages/settings_page.dart';
import 'pages/home_page.dart';
import 'pages/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = Auth();
  await auth.loadFromPrefs();
  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  final Auth auth;

  const MyApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.brown).copyWith(
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'YA Coffee',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color(0xFFFFF8F1),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: colorScheme.onPrimary,
            ),
          ),
          // remove default blue highlights by setting splash and highlight colors
          // use withAlpha to avoid precision-loss deprecation of withOpacity
          splashColor: colorScheme.primary.withAlpha((0.12 * 255).round()),
          highlightColor: colorScheme.primary.withAlpha((0.08 * 255).round()),
        ),
        initialRoute: '/auth',
        routes: {
          '/': (context) => const HomePage(),
          '/products': (context) => ProductsPage(),
          '/orders': (context) => OrdersPage(),
          '/settings': (context) => SettingsPage(),
          '/auth': (context) => const AuthPage(),
        },
      ),
    );
  }
}
