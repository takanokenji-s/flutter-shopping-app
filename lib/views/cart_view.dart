import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// show means that only Cart class will be imported without CartItem (which exists in the same file)
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart'; //  as cart_item;

class CartView extends StatelessWidget {
  static const routeName = '/cart';

  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                const SizedBox(
                  width: 10,
                ),
                Chip(
                  backgroundColor: Colors.purple,
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                  ),
                  onPressed: () {
                    Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items().values.toList(), cart.totalAmount);
                    cart.clearCart();
                  },
                  child: const Text('Order Now'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        // Expanded uses all available space inside Column or Row Widgets
        Expanded(
          child: ListView.builder(
            itemCount: cart.items().length,
            itemBuilder: (ctx, i) => CartItem(
              id: cart.items().values.toList()[i].id,
              productId: cart.items().keys.toList()[i],
              quantity: cart.items().values.toList()[i].quantity,
              price: cart.items().values.toList()[i].price,
              title: cart.items().values.toList()[i].title,
            ),
          ),
        ),
      ]),
    );
  }
}
