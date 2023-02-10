import 'package:flutter/material.dart';

import './views/product_overview.dart';
import './views/product_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shopping App to Learn Flutter',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: Colors.purple, secondary: Colors.deepOrange),
        ),
        home: ProductOverview(),
        routes: {
          ProductDetail.routeName: ((context) => const ProductDetail()),
        });
  }
}
