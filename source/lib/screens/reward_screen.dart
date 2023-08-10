import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import '../providers/redeem.dart';
import '../providers/rewards.dart';

class RewardScreen extends StatefulWidget {
  static const routeName = '/reward-screen';
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  Future _rewardsFuture = Future.value();

  Future _obtainRewardsFuture() {
    return Provider.of<Rewards>(context, listen: false).fetchAndSetRewards();
  }

  @override
  void initState() {
    _rewardsFuture = _obtainRewardsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<Product>;
    print(products);
    print('build reward');
    return FutureBuilder(
        future: _rewardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              print(snapshot.error);
              return Center(child: Text('An error occurred!'));
            } else {
              final item = Provider.of<Rewards>(context, listen: false).items;
              print(item);
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Rewards'),
                  centerTitle: true,
                ),
                body: ListView.builder(
                  itemCount: item!.length,
                  itemBuilder: (context, index) {
                    final rewardItem = products
                        .firstWhere((element) => element.id == item[index].id);
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(rewardItem.imageUrl),
                        ),
                        title: Text(
                          rewardItem.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Valid until ${DateFormat('d.MM.y').format(item[index].date)}',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        trailing: FilledButton(
                          onPressed: () {
                            if (Provider.of<Redeems>(context, listen: false)
                                    .total >=
                                item[index].point) {
                              Provider.of<Redeems>(context, listen: false)
                                  .usedRedeem(
                                      item[index].point, DateTime.now());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You have redeemed ${rewardItem.title}!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You do not have enough points!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text(
                            '${item[index].point.toString()} pts',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        });
  }
}
