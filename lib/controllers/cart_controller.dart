/// بنية MVC - طبقة التحكم
///
/// تتعامل وحدة التحكم هذه مع منطق أعمال عربة التسوق بنمط MVC.
/// يدير عناصر عربة التسوق والكميات وحسابات التسعير وعمليات عربة التسوق.
///
/// جزء من بنية MVC حيث:
/// - النموذج: هياكل البيانات في /models/
/// - العرض: مكونات واجهة المستخدم في /views/
/// - وحدة التحكم: منطق الأعمال (هذا الملف)
import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  int quantity;
  final double price;
  final String? image;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.image,
  });
}

class CartController extends GetxController {
  final _items = <String, CartItem>{}.obs;

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  // total number of units in the cart (sum of quantities)
  int get totalItems => _items.values.fold(0, (s, i) => s + i.quantity);

  double get totalPrice {
    double total = 0.0;
    for (var item in _items.values) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem(String id, String name, double price, {String? image}) {
    _items.value = {
      ..._items,
      if (_items.containsKey(id))
        id: CartItem(
          id: id,
          name: name,
          quantity: _items[id]!.quantity + 1,
          price: price,
          image: image,
        )
      else
        id: CartItem(
          id: id,
          name: name,
          quantity: 1,
          price: price,
          image: image,
        ),
    };
  }

  // decrease one unit of the given item; remove it when quantity reaches zero
  void decreaseItem(String id) {
    if (!_items.containsKey(id)) return;
    final item = _items[id]!;
    final newQuantity = item.quantity - 1;
    if (newQuantity <= 0) {
      _items.remove(id);
    } else {
      _items.value = {
        ..._items,
        id: CartItem(
          id: id,
          name: item.name,
          quantity: newQuantity,
          price: item.price,
          image: item.image,
        ),
      };
    }
  }

  void removeItem(String id) {
    _items.remove(id);
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      if (quantity <= 0) {
        _items.remove(id);
      } else {
        _items.value = {
          ..._items,
          id: CartItem(
            id: id,
            name: _items[id]!.name,
            quantity: quantity,
            price: _items[id]!.price,
            image: _items[id]!.image,
          ),
        };
      }
    }
  }

  void clear() {
    _items.clear();
  }
}