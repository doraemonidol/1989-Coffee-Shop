import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  static const routeName = '/order-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.modulate,
                ),
                child: Image(
                  image: AssetImage('assets/images/take-away.png'),
                  width: 180,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Order Success',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Your order has been placed successfully. For more details, go to my orders.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/orders');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Text('Track My Order'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
