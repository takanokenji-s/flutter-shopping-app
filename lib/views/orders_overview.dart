import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/layouts/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersOverview extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersOverview({super.key});

  @override
  State<OrdersOverview> createState() => _OrdersOverviewState();
}

class _OrdersOverviewState extends State<OrdersOverview> {
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.orders.length,
              itemBuilder: (ctx, index) => OrderItem(orders.orders[index]),
            ),
    );
  }
}
