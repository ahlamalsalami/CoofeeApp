/// هندسة MVC - طبقة العرض
///
/// يعرض هذا العرض الشاشة الرئيسية بنمط MVC.
/// يعرض واجهة المستخدم ويتفاعل مع وحدات التحكم لمنطق الأعمال.
///
/// جزء من بنية MVC حيث:
/// - النموذج: هياكل البيانات في /models/
/// - عرض: مكونات واجهة المستخدم (هذا الملف)
/// - وحدة التحكم: منطق الأعمال في /وحدات التحكم/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  Widget _buildCartButton(BuildContext context) {
    final cartController = Get.find<CartController>();
    
    return Obx(() => Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Get.toNamed('/orders'),
            ),
            if (cartController.totalItems > 0)
              Positioned(
                right: 6,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${cartController.totalItems}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [_buildCartButton(context)],
      ),
      drawer: Drawer(
        child: Obx(() => ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.brown),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage(
                          'assets/images/واجهه.jpg',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'drawer_header'.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        controller.email.value.isEmpty ? 'not_logged_in'.tr : controller.email.value,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.coffee),
                  title: Text('products'.tr),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed('/products');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text('my_orders'.tr),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed('/orders');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('settings'.tr),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed('/settings');
                  },
                ),
                if (controller.isAuth.value)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text('logout'.tr),
                    onTap: () {
                      controller.logout();
                      Navigator.of(context).pop();
                      Get.offAllNamed('/auth');
                    },
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: Text('login'.tr),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed('/auth');
                    },
                  ),
              ],
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.coffee_maker, size: 100, color: Colors.brown),
            const SizedBox(height: 20),
            Text(
              'home_welcome'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('explore_nav'.tr),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () => Get.toNamed('/products'),
              child: Text('view_menu'.tr, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
