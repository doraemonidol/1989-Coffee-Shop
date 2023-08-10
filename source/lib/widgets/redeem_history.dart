import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/redeem.dart';

class RedeemHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                Provider.of<Redeems>(context, listen: true).redeems.length,
            itemBuilder: (ctx, i) {
              final e = Provider.of<Redeems>(context, listen: true).redeems[i];
              return Column(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.background,
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: ListTile(
                      title: Text(e.title),
                      subtitle: Text(
                          DateFormat('d MMM | h:mm a').format(e.dateTime),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.grey,
                                  )),
                      trailing: Text(
                        '${e.point > 0 ? '+' : ''}${e.point} Pts',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider()),
                ],
              );
            }),
      ),
    );
  }
}
