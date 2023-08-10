import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/redeem.dart';

class LoyaltyCard extends StatelessWidget {
  var _deviceSize;
  var cntActivated;

  Widget sticker(String s, BuildContext context, bool isActivated) {
    return Container(
      alignment: Alignment.center,
      width: _deviceSize.width / 7 * 0.7,
      height: _deviceSize.width / 7 * 0.7,
      decoration: BoxDecoration(
        color: isActivated
            ? Theme.of(context).colorScheme.tertiary
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(100),
      ),
      child: FittedBox(
        alignment: Alignment.bottomCenter,
        child: Text(
          s,
          textHeightBehavior:
              TextHeightBehavior(applyHeightToLastDescent: false),
          style: TextStyle(
            color: isActivated
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context)
                    .colorScheme
                    .onTertiaryContainer
                    .withOpacity(0.2),
            fontWeight: FontWeight.w600,
            fontFamily: 'TSHandwriting',
            fontSize: 80,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    cntActivated = Provider.of<Redeems>(context, listen: true).loyaltyCnt;
    print('loyalty card build');
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: _deviceSize.width * 0.05,
        vertical: 10,
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Loyalty Card',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '  $cntActivated/7',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  sticker('s', context, 1 <= cntActivated),
                  sticker('w', context, 2 <= cntActivated),
                  sticker('i', context, 3 <= cntActivated),
                  sticker('f', context, 4 <= cntActivated),
                  sticker('t', context, 5 <= cntActivated),
                  sticker('i', context, 6 <= cntActivated),
                  sticker('e', context, 7 <= cntActivated),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
