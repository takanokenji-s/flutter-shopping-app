import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/product_detail.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    /* Provider method forces this Widget to rebuild entirely
     * if data changes.
     * use this way if you need everything to be rebuild
     * reminder: listen false forces product to not listen changes if occurs
     * */
    final product = Provider.of<Product>(context); // , listen: false
    final cart = Provider.of<Cart>(context, listen: false);

    /**
     * This method does not forces all widget to rebuild if data changes
     */
    return // Consumer<Product>(
        // builder: (ctx, product, child) =>
        ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          /**
           * By using Consumer like this, it forces
           * listening changes but in a small part of the
           * Widget (the icon button in this case)
           */
          leading: Consumer<Product>(
              // use _ instead of child if don't need
              builder: (ctx, product, child) => IconButton(
                    // label: child, // a label I would like and should be in child property
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                  ) /*, child: Text('something I would like in a label sample') */),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: (() {
              cart.addItem(product.id, product.price, product.title);
            }),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetail.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
