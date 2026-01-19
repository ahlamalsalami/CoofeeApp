import 'package:get/get.dart';

import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../views/auth_page.dart';
import '../views/home_page.dart';
import '../views/orders_page.dart';
import '../views/products_page.dart';
import '../views/settings_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => ProductsPage(),
    ),
    GetPage(
      name: Routes.ORDERS,
      page: () => OrdersPage(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsPage(),
    ),
  ];
}