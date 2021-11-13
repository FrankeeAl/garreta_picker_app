import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product>? _items = [];
  final baseUrl =
      'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/';
  //
  List<Product>? get items {
    return [..._items!];
  }

  Future<void> fetchProducts() async {
    print('been here in fetch products');
    final CATEGORY_PATH = 'products.json?orderBy="sellerId"&equalTo="$userId"';
    List<Product> loadedProducts = [];
    try {
      final response = await http.get(Uri.parse(baseUrl + CATEGORY_PATH));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        print('walay data nakuha.');
        return;
      }
      extractedData.forEach((prodId, json) {
        loadedProducts.add(
          Product(
            id: prodId.toString(),
            barcode: json['barcode'],
            brand: json['brand'],
            category: json['category'],
            description: json['description'],
            discountedPrice: json['discountedPrice'],
            imageUrl: json['imageUrl'],
            maxQtyStore: json['maxQtyStore'],
            minQtyStore: json['minQtyStore'],
            qtyCeiling: json['qtyCeiling'],
            qtyOnHand: json['qtyOnHand'],
            rack: json['rack'],
            rateItem: json['rateItem'],
            reOrderLevel: json['reOrderLevel'],
            sellerId: json['sellerId'],
            sellingPrice: json['sellingPrice'],
            shelf: json['shelf'],
            smsCode: json['smsCode'],
            title: json['title'],
            unit: json['unit'],
            weight: json['weight'],
          ),
        );
      });
      // final products = Product.fromRTDB(extractedData);

      _items = loadedProducts;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
    notifyListeners();
    print('been here in products...');
  }

  List<Product>? findById(String id) {
    print('${_items!.length} gikan ni sa findbyId');
    return _items!.where((element) => element.id == id).toList();
  }
}

class OrderedProduct with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final int quantity;
  final double? price;

  OrderedProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
  });
}
