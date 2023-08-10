import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String description;
  final String note;
  var quantity = 0;

  int get getPoint {
    return price.round() * quantity * 4;
  }

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.note,
    this.quantity = 1,
  });

  toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'note': note,
      'quantity': quantity,
    };
  }
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem>? get items {
    return _items;
  }

  updateCart(List<CartItem> newProduct) {
    _items = newProduct.map((e) => e).toList();
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key) {
      total += key.price * key.quantity;
    });
    return total;
  }

  void addItem(CartItem newItem) {
    _items
            .where((e) =>
                e.id == newItem.id &&
                e.title == newItem.title &&
                e.description == newItem.description)
            .toList()
            .isEmpty
        ? _items.add(newItem)
        : _items.forEach((element) {
            if (element.id == newItem.id &&
                element.title == newItem.title &&
                element.description == newItem.description) {
              element.quantity += newItem.quantity;
            }
          });
    print('an item added to cart');
    print(_items.length);
    notifyListeners();
  }

  void removeItem(
    CartItem newItem,
  ) {
    _items.removeWhere((element) =>
        element.id == newItem.id &&
        element.title == newItem.title &&
        element.description == newItem.description);
    notifyListeners();
  }

  void removeSingleItem(CartItem newItem, int quantity) {
    final i = _items.indexWhere((element) =>
        element.id == newItem.id &&
        element.title == newItem.title &&
        element.description == newItem.description);

    if (_items[i].quantity > quantity) {
      _items[i].quantity -= quantity;
    } else {
      _items.remove(newItem);
    }
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}

mixin OrderItem {}
