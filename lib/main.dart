import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/cart_view.dart';
import './views/product_overview.dart';
import './views/product_detail.dart';
import './views/orders_overview.dart';
import './views/user_products_overview.dart';
import './views/edit_product.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping App to Learn Flutter',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: Colors.purple, secondary: Colors.deepOrange),
        ),
        home: const ProductOverview(),
        routes: {
          ProductDetail.routeName: (context) => const ProductDetail(),
          CartView.routeName: (context) => const CartView(),
          OrdersOverview.routeName: (ctx) => const OrdersOverview(),
          UserProducts.routeName: (ctx) => const UserProducts(),
          EditProduct.routeName: (ctx) => const EditProduct(),
        },
      ),
    );
  }
}
