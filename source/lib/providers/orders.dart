import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  String status;
  final String location;

  void changeStatus(String newStatus) {
    status = newStatus;
  }

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    this.status = 'On Going',
    required this.location,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<OrderItem> get onGoingOrders {
    return _orders.where((element) => element.status == 'On Going').toList();
  }

  List<OrderItem> get completedOrders {
    return _orders.where((element) => element.status != 'On Going').toList();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    try {
      print('fetching orders');
      final response = await http.get(Uri.parse(url));
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            status: orderData['status'],
            location: orderData['location'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                    note: item['note'],
                    description: item['description'],
                  ),
                )
                .toList(),
          ),
        );
      });
      print('fetching orders done');
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      DateTime timestamp, String location) async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'status': 'On Going',
          'location': location,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'description': cp.description,
                    'note': cp.note,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
        status: 'On Going',
        location: 'Unknown',
      ),
    );
    notifyListeners();
  }

  Future<void> updateOrder(OrderItem newOrder) async {
    final prodIndex = _orders.indexWhere((prod) => prod.id == newOrder.id);
    if (prodIndex >= 0) {
      final url =
          'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId/${newOrder.id}.json?auth=$authToken';
      print('updating order');
      await http.patch(Uri.parse(url),
          body: json.encode({
            'amount': newOrder.amount,
            'dateTime': newOrder.dateTime.toIso8601String(),
            'status': newOrder.status,
            'location': newOrder.location,
            'products': newOrder.products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'description': cp.description,
                      'note': cp.note,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders[prodIndex] = newOrder;
      print('updating order done');
      notifyListeners();
    } else {
      print('...');
    }
  }
}
