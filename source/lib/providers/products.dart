import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // } else {
    return [..._items];
    // }
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> get featureItem {
    return _items.where((prodItem) => prodItem.isFeatured).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    print('fetching products');
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      print('fetching favorites');
      final favoriteResponse = await http.get(Uri.parse(
          'https://coffee-shop-1989-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken'));
      final favoriteData = json.decode(favoriteResponse.body);
      print(favoriteData);
      final List<Product> loadedProducts = [];
      for (int i = 0; i < extractedData.length; i++) {
        loadedProducts.add(Product(
          id: i.toString(),
          title: extractedData[i]['title'],
          description: extractedData[i]['description'],
          price: double.parse(extractedData[i]['price'].toString()),
          imageUrl: extractedData[i]['image'],
          categories: (extractedData[i]['category']).cast<String>(),
          ingredients: (extractedData[i]['ingredients']).cast<String>(),
          isFeatured: (extractedData[i]['isFeatured'] == null
              ? false
              : extractedData[i]['isFeatured']),
          isFavorite: favoriteData == null
              ? false
              : favoriteData[i.toString()] ?? false,
        ));
      }
      _items = loadedProducts;
      _items.sort((a, b) => a.title.compareTo(b.title));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
