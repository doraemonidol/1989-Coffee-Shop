import '../widgets/redeem_history.dart';

import '../widgets/loyalty_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_player.dart';

import '../providers/redeem.dart';
import '../widgets/redeem_point_card.dart';

class RedeemScreen extends StatelessWidget {
  var _deviceSize;
  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    final futureOrder =
        Provider.of<Redeems>(context, listen: false).fetchAndSetRedeems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: futureOrder,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              Provider.of<MusicPlayer>(context, listen: false)
                  .playSong('sounds/NewRomanticsInstrumental.mp3');
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  children: [
                    LoyaltyCard(),
                    RedeemPointCard(),
                    RedeemHistory(),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
