import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildCartButton(BuildContext context) {
    return Consumer<Cart>(
      builder: (ctx, cart, _) {
        final count = cart.totalItems;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.of(context).pushNamed('/orders'),
            ),
            if (count > 0)
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
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق القهوة'),
        actions: [_buildCartButton(context)],
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder:
              (ctx, auth, _) => ListView(
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
                        const Text(
                          'YA Coffee',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          auth.email ?? 'غير مسجل',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.coffee),
                    title: const Text('المنتجات'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/products');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('طلباتي'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/orders');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('الإعدادات'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/settings');
                    },
                  ),
                  auth.isAuth
                      ? ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('تسجيل الخروج'),
                        onTap: () {
                          Provider.of<Auth>(context, listen: false).logout();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/auth');
                        },
                      )
                      : ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text('تسجيل الدخول'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/auth');
                        },
                      ),
                ],
              ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.coffee_maker, size: 100, color: Colors.brown),
            const SizedBox(height: 20),
            const Text(
              'مرحباً بك في مقهى التعلم',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('اختر من قائمة التنقل لبدء الاستكشاف'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/products'),
              child: const Text('عرض القائمة', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
