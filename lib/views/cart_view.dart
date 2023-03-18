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
                OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.purple),
      ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items().values.toList(), widget.cart.totalAmount);
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Order Now'),
    );
  }
}
