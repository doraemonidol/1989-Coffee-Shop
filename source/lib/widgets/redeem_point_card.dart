import '../providers/products.dart';

import '../screens/reward_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rewards.dart';

import '../providers/redeem.dart';

class RedeemPointCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: _deviceSize.width * 0.05,
        vertical: 10,
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Points: '),
                Text(
                  '${Provider.of<Redeems>(context, listen: true).total}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .fetchAndSetProducts()
                    .then((_) {
                  Navigator.of(context).pushNamed(
                    RewardScreen.routeName,
                    arguments:
                        Provider.of<Products>(context, listen: false).items,
                  );
                });
              },
              child: Text('Redeem'),
            ),
          ],
        ),
      ),
    );
  }
}
