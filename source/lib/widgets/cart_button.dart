import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart.dart';

class CartButton extends StatelessWidget {
  Color? _color = null;

  CartButton([this._color]);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (_, cart, ch) => Center(
        child: Badge(
          child: ch,
          label: Text(
            cart.itemCount.toString(),
          ),
          offset: Offset(
            -5,
            5,
          ),
        ),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
        },
        icon: _color == null
            ? Icon(
                Icons.shopping_cart,
              )
            : Icon(
                Icons.shopping_cart,
                color: _color!,
              ),
      ),
    );
  }
}
