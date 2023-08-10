import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Reward {
  final String id;
  final DateTime date;
  final int point;

  Reward({
    required this.id,
    required this.date,
    required this.point,
  });
}

class Rewards with ChangeNotifier {
  List<Reward> _items = [];
  final String authToken;
  final String userId;

  Rewards(this.authToken, this.userId);

  List<Reward>? get items {
    return _items;
  }

  Future<void> fetchAndSetRewards() async {
    print('fetching rewards');
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/reward.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      print(response.body);
      print(extractedData);
      final List<Reward> loadedRewards = [];
      for (int i = 0; i < extractedData.length; i++) {
        loadedRewards.add(Reward(
          id: extractedData[i]['id'].toString(),
          date: DateTime.parse(extractedData[i]['date']),
          point: int.parse(extractedData[i]['point'].toString()),
        ));
      }
      _items = loadedRewards;

      for (int i = 0; i < _items.length; i++) {
        if (_items[i].date.isBefore(DateTime.now())) {
          _items.removeAt(i);
        }
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteReward(String id) async {
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/reward/$id.json?auth=$authToken';
    final existingRewardIndex = _items.indexWhere((reward) => reward.id == id);
    var existingReward = _items[existingRewardIndex];
    _items.removeAt(existingRewardIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingRewardIndex, existingReward);
      notifyListeners();
      throw HttpException('Could not delete reward.');
    }
    existingReward = Reward(
      id: '',
      date: DateTime.now(),
      point: 0,
    );
  }
}
