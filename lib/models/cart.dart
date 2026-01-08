import 'package:flutter/foundation.dart';

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

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

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
    if (_items.containsKey(id)) {
      _items[id]!.quantity += 1;
    } else {
      _items[id] = CartItem(
        id: id,
        name: name,
        quantity: 1,
        price: price,
        image: image,
      );
    }
    notifyListeners();
  }

  // decrease one unit of the given item; remove it when quantity reaches zero
  void decreaseItem(String id) {
    if (!_items.containsKey(id)) return;
    final item = _items[id]!;
    item.quantity -= 1;
    if (item.quantity <= 0) {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      if (quantity <= 0) {
        _items.remove(id);
      } else {
        _items[id]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
