import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavValue (bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final updateUrl = Uri.parse(
        'https://fine-avatar-234209-default-rtdb.firebaseio.com/products/$id.json');
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;

    try {
      final response = await http.patch(
        updateUrl,
        body: json.encode({
          'isFavourite': isFavorite,
        }),
      );

      if (response.statusCode >= 400){
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }

    notifyListeners();
  }
}
