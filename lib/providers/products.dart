import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    )
  ];

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

  // this forces _items to be added inside this method
  // as it forces to add here, notifyListeners can be triggered
  void addProduct(product) {
    // TODO: make a addProduct after all logic is done
    // _items.add(product);
    notifyListeners();
  }
}
