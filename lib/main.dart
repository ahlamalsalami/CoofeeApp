import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'services/language_service.dart';
import 'languages/ar_translation.dart';
import 'languages/en_translation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetX services
  Get.put(LanguageService());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.brown).copyWith(
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YA Coffee',
      translations: MyTranslations(),
      locale: Locale(LanguageService.to.getCurrentLanguage()),
      fallbackLocale: const Locale('ar'),
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
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': ArTranslation.translation,
        'en': EnTranslation.translation,
      };
}
