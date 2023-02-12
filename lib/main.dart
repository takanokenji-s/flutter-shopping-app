import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/product_overview.dart';
import './views/product_detail.dart';
import './providers/products.dart';
import './providers/cart.dart';

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
            ProductDetail.routeName: ((context) => const ProductDetail()),
          }),
    );
  }
}
