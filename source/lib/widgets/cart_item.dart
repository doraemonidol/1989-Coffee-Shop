import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' as ord;
import '../providers/products.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String description;
  final String note;

  const CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.description,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(id);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Card(
          elevation: 5,
          child: Container(
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onError,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<ord.Cart>(context, listen: false).removeItem(ord.CartItem(
          id: id,
          title: title,
          price: price,
          note: note,
          description: description,
        ));
      },
      child: Card(
        elevation: 5,
        color: Theme.of(context).colorScheme.background,
        margin: EdgeInsets.only(
          bottom: 12,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.background,
          ),
          alignment: Alignment.centerLeft,
          //height: 90,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Container(
                    width: 70,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: Size(120, 90),
                          child: FadeInImage(
                            placeholder:
                                AssetImage('assets/images/coffee-cup.png'),
                            image: NetworkImage(loadedProduct.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                      Text('Total: \$${(price * quantity)}'),
                    ],
                  ),
                  trailing: Text('${quantity} x'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
