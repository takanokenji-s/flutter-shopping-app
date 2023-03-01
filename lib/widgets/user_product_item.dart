import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../views/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProduct.routeName, arguments: id);
            },
            color: Colors.purple,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (err) {
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Delete Fail!',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            color: Colors.red,
          ),
        ]),
      ),
    );
  }
}
