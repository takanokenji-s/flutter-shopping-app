import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/cart_view.dart';
import './views/product_overview.dart';
import './views/product_detail.dart';
import './views/orders_overview.dart';
import './views/user_products_overview.dart';
import './views/edit_product.dart';
import './views/auth_screen.dart';
import './views/splash_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(
              null, null, []), // faço nem ideia se isso vai funcionar kkkk
          update: (ctx, auth, previousProducts) {
            print(auth.token);
            return Products(auth.token, auth.userId,
                previousProducts == null ? [] : previousProducts.items);
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
              auth.token!,
              auth.userId!,
              previousOrders!.orders.isNotEmpty ? previousOrders.orders : []),
          create: (_) => Orders('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shopping App to Learn Flutter',
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Colors.purple, secondary: Colors.deepOrange),
          ),
          home: auth.isAuth
              ? const ProductOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetail.routeName: (context) => const ProductDetail(),
            CartView.routeName: (context) => const CartView(),
            OrdersOverview.routeName: (ctx) => const OrdersOverview(),
            UserProducts.routeName: (ctx) => const UserProducts(),
            EditProduct.routeName: (ctx) => const EditProduct(),
          },
        ),
      ),
    );
  }
}
