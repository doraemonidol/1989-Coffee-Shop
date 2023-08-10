import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/user.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import '../providers/redeem.dart';
import './order_success_screen.dart';
import '../providers/music_player.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.background.withOpacity(1),
        elevation: 5,
        height: 100,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              OrderButton(cart: cart),
            ],
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (ctx, i) => CartItem(
                  id: cart.items![i].id,
                  title: cart.items![i].title,
                  quantity: cart.items![i].quantity,
                  price: cart.items![i].price,
                  description: cart.items![i].description,
                  note: cart.items![i].note,
                ),
                itemCount: cart.itemCount,
              ),
            )
          ],
        ),
      ),
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
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 200,
      child: FilledButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                final timestamp = DateTime.now();
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items!,
                    widget.cart.totalAmount,
                    timestamp,
                    Provider.of<User>(context, listen: false).address);
                int cnt = 0;
                for (int i = 0; i < widget.cart.items!.length; i++) {
                  await Provider.of<Redeems>(context, listen: false)
                      .addRedeem(widget.cart.items![i], timestamp);
                  cnt += widget.cart.items![i].quantity;
                }
                await Provider.of<User>(context, listen: false)
                    .updateUser(newLoyaltyPoints: cnt % 7);
                setState(() {
                  _isLoading = false;
                });
                Provider.of<MusicPlayer>(context, listen: false)
                    .playSong('sounds/ShakeItOffInstrumental.mp3');
                widget.cart.clear();
                Navigator.of(context)
                    .popUntil((route) => !Navigator.of(context).canPop());
                Navigator.of(context).pushNamed(OrderSuccessScreen.routeName);
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Checkout'),
                ],
              ),
      ),
    );
  }
}
