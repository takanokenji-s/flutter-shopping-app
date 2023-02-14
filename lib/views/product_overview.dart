import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import './cart_view.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilteringOptions {
  favorites,
  all,
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({super.key});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _filterFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartView.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilteringOptions selected) {
              setState(() {
                if (selected == FilteringOptions.favorites) {
                  _filterFavorites = true;
                } else {
                  _filterFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilteringOptions.favorites,
                child: Text('Filter Favorites'),
              ),
              const PopupMenuItem(
                value: FilteringOptions.all,
                child: Text('Disable Filter'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
        title: const Text('Shopping App'),
      ),
      body: ProductsGrid(_filterFavorites),
    );
  }
}
