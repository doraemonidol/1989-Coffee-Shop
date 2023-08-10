import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/music_player.dart';
import '../widgets/order_item.dart' as ord;
import './tabs_screen.dart';

enum Status { onGoing, completed }

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture = Future.value();
  List<bool> isSelected = [true, false];

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    Provider.of<MusicPlayer>(context, listen: false)
        .playSong('sounds/WildestDreamsInstrumental.mp3');
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        centerTitle: true,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Provider.of<MusicPlayer>(context, listen: false)
                      .playSong('sounds/WelcomeToNewYorkInstrumental.mp3');
                  Navigator.of(context).pop();
                  //Navigator.of(context).pushReplacementNamed('/');
                },
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            } else {
              return Column(
                children: [
                  Center(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                            }
                          });
                        },
                        renderBorder: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0)),

                        //selectedBorderColor: Colors.red[700],
                        selectedColor: Theme.of(context).colorScheme.primary,
                        //fillColor: Colors.red[200],
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.2),
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 80.0,
                        ),
                        isSelected: isSelected,
                        children: [
                          Container(
                            //padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected[0]
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            width: width * 0.30,
                            height: 60,
                            child: Container(
                              width: width * 0.30,
                              child: Text('On Going'),
                              color: Theme.of(context).colorScheme.background,
                              alignment: Alignment.center,
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected[1]
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            width: width * 0.30,
                            height: 60,
                            child: Container(
                              width: width * 0.30,
                              child: Text('History'),
                              color: Theme.of(context).colorScheme.background,
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Consumer<Orders>(
                    builder: (ctx, orderData, child) {
                      final order = isSelected[0]
                          ? orderData.onGoingOrders
                          : orderData.completedOrders;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: order.length,
                          itemBuilder: (ctx, i) => GestureDetector(
                            onTap: () {
                              order[i].changeStatus('Completed');
                              Provider.of<Orders>(context, listen: false)
                                  .updateOrder(order[i]);
                            },
                            child: ord.OrderItem(
                              order[i],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
