import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class RedeemItem {
  final String title;
  final DateTime dateTime;
  final int point;

  RedeemItem({
    required this.title,
    required this.dateTime,
    required this.point,
  });
}

class Redeems with ChangeNotifier {
  List<RedeemItem> _redeems = [];
  final String authToken;
  final String userId;
  var loyaltyCnt = 0;
  final int LOYALTY_POINT = 100;
  final int MAX_LOYALTY = 7;

  Redeems(this.authToken, this.userId, this._redeems);

  int get total {
    return _redeems.fold(
        0, (previousValue, element) => previousValue + element.point);
  }

  void setLoyaltyCount(int cnt) {
    loyaltyCnt = cnt;
  }

  List<RedeemItem> get redeems {
    print('get redeems');
    return [..._redeems];
  }

  Future<void> fetchAndSetRedeems() async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/redeems/$userId.json?auth=$authToken';
    try {
      print('fetching redeems');
      final response = await http.get(Uri.parse(url));
      final List<RedeemItem> loadedRedeems = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((redeemId, redeemData) {
        loadedRedeems.add(
          RedeemItem(
            title: redeemData['title'],
            dateTime: DateTime.parse(redeemData['dateTime']),
            point: redeemData['point'],
          ),
        );
      });
      print('fetching redeems done');
      _redeems = loadedRedeems.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addRedeem(CartItem item, DateTime date,
      [bool loyalty = false]) async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/redeems/$userId.json?auth=$authToken';
    if (!loyalty && item.getPoint == 0) {
      return;
    }
    print(
      'adding redeem',
    );

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'title': '${item.title}' +
              (item.quantity <= 1 ? '' : ' x${item.quantity}'),
          'dateTime': date.toIso8601String(),
          'point': (loyalty ? item.price.floor() : item.getPoint),
        }));
    _redeems.insert(
      0,
      RedeemItem(
        title:
            '${item.title}' + (item.quantity <= 1 ? '' : ' x${item.quantity}'),
        dateTime: date,
        point: (loyalty ? item.price.floor() : item.getPoint),
      ),
    );
    loyaltyCnt += item.quantity;
    if (loyaltyCnt >= MAX_LOYALTY) {
      addRedeem(
          CartItem(
            id: 'loyalty',
            title: 'Loyalty',
            price: LOYALTY_POINT.toDouble(),
            description: 'Loyalty',
            note: 'Loyalty',
            quantity: 0,
          ),
          date,
          true);
      loyaltyCnt -= MAX_LOYALTY;
    }
    notifyListeners();
  }

  Future<void> usedRedeem(int point, DateTime date) async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/redeems/$userId.json?auth=$authToken';

    print(
      'using redeem',
    );

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'title': 'Used Redeem',
          'dateTime': date.toIso8601String(),
          'point': -point,
        }));
    _redeems.insert(
      0,
      RedeemItem(
        title: 'Used Redeem',
        dateTime: date,
        point: -point,
      ),
    );
    notifyListeners();
  }
}
