import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';

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
    final cart = Provider.of<Cart>(context, listen: false);
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
      cart.updateQuantity(item.id, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة الطلبات'),
        backgroundColor: Colors.brown,
      ),
      body: Consumer<Cart>(
        builder: (ctx, cart, _) {
          if (cart.itemCount == 0) {
            return const Center(child: Text('السلة فارغة'));
          }
          final items = cart.items.values.toList();
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
                                  Provider.of<Cart>(
                                    context,
                                    listen: false,
                                  ).decreaseItem(it.id);
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
                                  Provider.of<Cart>(
                                    context,
                                    listen: false,
                                  ).addItem(
                                    it.id,
                                    it.name,
                                    it.price,
                                    image: it.image,
                                  );
                                },
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(4),
                                iconSize: 26,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'حذف',
                                onPressed: () {
                                  Provider.of<Cart>(
                                    context,
                                    listen: false,
                                  ).removeItem(it.id);
                                },
                              ),
                            ],
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
                      'المجموع: ${cart.totalPrice.toStringAsFixed(2)} SAR',
                      style: const TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                      ),
                      onPressed: () {
                        // Placeholder for checkout
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تمت عملية الدفع (تجريبي)'),
                          ),
                        );
                        cart.clear();
                      },
                      child: const Text('الدفع'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
