import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  // This helper used to be reachable from UI in earlier versions.
  // It's kept for compatibility but currently not referenced directly.
  // ignore: unused_element
  Future<void> _showEditQuantityDialog(
    BuildContext context,
    CartItem item,
  ) async {
    final controller = TextEditingController(text: item.quantity.toString());
    final cartController = Get.find<CartController>();
    final result = await showDialog<int?>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('تعديل الكمية'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الكمية'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  final q = int.tryParse(controller.text) ?? item.quantity;
                  Navigator.of(ctx).pop(q);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
    );

    if (result != null) {
      cartController.updateQuantity(item.id, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة الطلبات'),
        backgroundColor: Colors.brown,
      ),
      body: Obx(() {
        if (cartController.itemCount == 0) {
          return const Center(child: Text('السلة فارغة'));
        }
        final items = cartController.items.values.toList();
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (c, i) {
                  final it = items[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Slidable(
                      key: ValueKey(it.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (ctx) {
                              cartController.removeItem(it.id);
                              Get.snackbar(
                                'تم الحذف',
                                '${it.name} تم حذفه',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'حذف',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading:
                            it.image != null
                                ? CircleAvatar(
                                  backgroundImage: AssetImage(it.image!),
                                )
                                : const CircleAvatar(
                                  child: Icon(Icons.local_cafe),
                                ),
                        title: Text(it.name),
                        subtitle: Text(
                          'سعر الوحدة: ${it.price} - الكمية: ${it.quantity}',
                        ),
                        trailing: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 150,
                            maxWidth: 220,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.all(4),
                                iconSize: 26,
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  cartController.decreaseItem(it.id);
                                },
                              ),
                              Text(
                                '${it.quantity}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(4),
                                iconSize: 26,
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  cartController.addItem(
                                    it.id,
                                    it.name,
                                    it.price,
                                    image: it.image,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المجموع: ${cartController.totalPrice.toStringAsFixed(2)} SAR',
                    style: const TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    onPressed: () {
                      // Placeholder for checkout
                      Get.snackbar(
                        'تمت العملية',
                        'تمت عملية الدفع (تجريبي)',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      cartController.clear();
                    },
                    child: const Text('الدفع'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
