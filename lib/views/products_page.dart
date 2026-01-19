import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

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

  static final List<Map<String, dynamic>> sampleProducts = [
    {
      'id': 'p1',
      'name': 'قهوة عربية',
      'price': 12.0,
      'image': 'assets/images/turkish-coffee.png',
    },
    {
      'id': 'p2',
      'name': 'إسبريسو',
      'price': 9.0,
      'image': 'assets/images/espresso.png',
    },
    {
      'id': 'p3',
      'name': 'لاتيه',
      'price': 11.0,
      'image': 'assets/images/latte.png',
    },
    {
      'id': 'p4',
      'name': 'قهوة مثلجة',
      'price': 13.0,
      'image': 'assets/images/iced-coffee.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        actions: [_buildCartButton(context)],
      ),
      body: ListView.builder(
        itemCount: sampleProducts.length,
        itemBuilder: (ctx, i) {
          final p = sampleProducts[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(p['image']),
                backgroundColor: Colors.grey[200],
              ),
              title: Text(p['name']),
              subtitle: Text('${p['price'].toString()} SAR'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text('أضف'),
                onPressed: () {
                  Get.find<CartController>().addItem(p['id'], p['name'], p['price'], image: p['image']);
                  Get.snackbar(
                    'تم الإضافة',
                    '${p['name']} أضيفت إلى السلة',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
