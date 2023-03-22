import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _setFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final initialStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = '${Constants.userFavorites}/$userId/$id.json?auth=$token';

      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(initialStatus);
      }
    } catch (err) {
      _setFavoriteValue(initialStatus);
    }
  }
}
