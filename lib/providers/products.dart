import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // var _filterFavorites = false;

  List<Product> get filterFavorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  // this return forces a return of a copy of items
  // if the return of this method is _items, then you got any return
  // whenever _items change internally
  List<Product> get items {
    // if (_filterFavorites) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // void filterFavorites() {
  //   _filterFavorites = true;
  //   notifyListeners();
  // }

  // void unfilterFavorites() {
  //   _filterFavorites = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    try {
      // remove .json from url to force errors
      const url =
          'https://learn-flutter-aa8f6-default-rtdb.firebaseio.com/products.json'; // .json';
      final response = await http.get(Uri.parse(url));
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      decodedResponse.forEach((productId, product) {
        loadedProducts.add(Product(
          id: productId,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: product['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // this forces _items to be added inside this method
  // as it forces to add here, notifyListeners can be triggered
  // in this method a async and await was applied, but the .then and .catchError will be comment
  // remove async and all awaits in order to use with then/catch and set return to http.post...
  Future<void> addProduct(Product product) async {
    // remove .json from url to force errors
    const url =
        'https://learn-flutter-aa8f6-default-rtdb.firebaseio.com/products.json'; // .json';
    // return
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      // .then((response) {
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      // _items.insert(0, newProduct); // to add as first item in the list
      _items.add(newProduct);
      notifyListeners();
      // }).catchError((err) {
      //   throw err;
      // });
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url =
          'https://learn-flutter-aa8f6-default-rtdb.firebaseio.com/products/$id.json';
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
    final url =
        'https://learn-flutter-aa8f6-default-rtdb.firebaseio.com/products/$id.json';
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
