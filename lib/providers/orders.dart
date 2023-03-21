import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://learn-flutter-aa8f6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> orders = [];
    final encodedOrders = json.decode(response.body) as Map<String, dynamic>;

    if (encodedOrders.isEmpty) return;

    encodedOrders.forEach((key, value) {
      orders.add(OrderItem(
        id: key,
        amount: value['amount'],
        products: (value['products'] as List<dynamic>)
            .map(
              (product) => CartItem(
                id: product['id'],
                price: product['price'],
                quantity: product['quantity'],
                title: product['title'],
              ),
            )
            .toList(),
        dateTime: DateTime.parse(value['dateTime']),
      ));
    });
    _orders = orders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://learn-flutter-aa8f6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'quantity': prod.quantity,
                    'price': prod.price
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );

    notifyListeners();
  }
}
