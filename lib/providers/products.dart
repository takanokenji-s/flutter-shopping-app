import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/constants.dart';
import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String? _authToken;
  final String? _userId;

  Products(this._authToken, this._userId, this._items);

  List<Product> get filterFavorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? '&orderBy="ownerId"&equalTo="$_userId"' : '';
      final url = '${Constants.productsJson}?auth=$_authToken$filterString';
      final response = await http.get(Uri.parse(url));
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;

      if (decodedResponse.isEmpty) return;

      final favoriteResponse = await http.get(Uri.parse(
          '${Constants.userFavorites}/$_userId.json?auth=$_authToken'));
      final encodedFavorite = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      decodedResponse.forEach((productId, product) {
        loadedProducts.add(
          Product(
            id: productId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite: encodedFavorite == null
                ? false
                : encodedFavorite[productId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url = '${Constants.productsJson}?auth=$_authToken';

      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'ownerId': _userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = '${Constants.products}/$id.json?auth=$_authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = '${Constants.products}/$id.json?auth=$_authToken';
    final index = _items.indexWhere((element) => element.id == id);
    Object? currentProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete product');
    } else {
      _items.insert(index, currentProduct as Product);
    }
    currentProduct = null;
  }
}
