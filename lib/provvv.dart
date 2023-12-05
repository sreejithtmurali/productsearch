import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:productsearch/model/Products.dart';
import 'package:productsearch/model/Respmain.dart';

class ProductProvider extends ChangeNotifier {
  List<Products> _products = [];
  List<Products> get products => _products;
  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      var json=jsonDecode(response.body.toString());
      var s=Respmain.fromJson(json);
      var list=s.products;
      _products=list!;
      notifyListeners();

    }
  }


  Future<void> fetchProducts(String query) async {
    if (query.length == 0) {
      fetchProduct();
    } else {
      final response = await http.get(
          Uri.parse('https://dummyjson.com/products/search?q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];

        _products = productsJson.map((productJson) =>
            Products(
              id: productJson['id'],
              title: productJson['title'],
              description: productJson['description'],
              price: productJson['price'].toDouble(),
              discountPercentage: productJson['discountPercentage'].toDouble(),
              rating: productJson['rating'].toDouble(),
              stock: productJson['stock'],
              brand: productJson['brand'],
              category: productJson['category'],
              thumbnail: productJson['thumbnail'],
              images: List<String>.from(productJson['images']),
            )).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    }
  }
}
