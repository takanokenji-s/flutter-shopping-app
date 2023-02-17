import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/layouts/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersOverview extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (ctx, index) => OrderItem(orders.orders[index]),
      ),
    );
  }
}
