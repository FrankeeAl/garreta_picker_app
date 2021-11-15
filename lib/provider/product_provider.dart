import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;
  bool selected = false;

  Products(this.authToken, this.userId, this._items);

  List<Product>? _items = [];

  bool get isSelected {
    return selected;
  }

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

  Future<void> addProduct(BuildContext context, Product product) async {
    final addPath = 'products.json?auth=$authToken';
    final url = baseUrl + addPath;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'name': product.id,
          'barcode': product.barcode,
          'brand': product.brand,
          'category': product.category,
          'description': product.description,
          'discountedPrice': product.discountedPrice,
          'imageUrl': product.imageUrl,
          'maxQtyStore': product.maxQtyStore,
          'minQtyStore': product.minQtyStore,
          'qtyCeiling': product.qtyCeiling,
          'qtyOnHand': product.qtyOnHand,
          'rack': product.rack,
          'rateItem': product.rateItem,
          'reOrderLevel': product.reOrderLevel,
          'sellerId': product.sellerId,
          'sellingPrice': product.sellingPrice,
          'shelf': product.shelf,
          'smsCode': product.smsCode,
          'title': product.title,
          'unit': product.unit,
          'weight': product.weight,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        barcode: product.barcode,
        brand: product.brand,
        category: product.category,
        description: product.description,
        discountedPrice: product.discountedPrice,
        imageUrl: product.imageUrl,
        maxQtyStore: product.maxQtyStore,
        minQtyStore: product.minQtyStore,
        qtyCeiling: product.qtyCeiling,
        qtyOnHand: product.qtyOnHand,
        rack: product.rack,
        rateItem: product.rateItem,
        reOrderLevel: product.reOrderLevel,
        sellerId: product.sellerId,
        sellingPrice: product.sellingPrice,
        shelf: product.shelf,
        smsCode: product.smsCode,
        title: product.title,
        unit: product.unit,
        weight: product.weight,
      );

      _items!.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      _showErrorDialog(e.toString(), context);
      rethrow;
    }
  }

  Future<void> updateProduct(
      String id, Product newProduct, int qtyOnHand, int reOrderLevel) async {
    final prodIndex = _items!.indexWhere((element) => element.id == id);
    final productPath = 'products/$id.json';
    final url = baseUrl + productPath;
    try {
      if (prodIndex >= 0) {
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            'qtyOnHand': newProduct.qtyOnHand,
            'reOrderLevel': newProduct.reOrderLevel,
          }),
        );
        _items![prodIndex] = newProduct;
        print('${newProduct.id} mao ning gi update');
        notifyListeners();
      } else {
        print('Ooops something happened.');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  List<Product> findById(String id) {
    print('$id gikan ni sa findbyId');
    return _items!.where((element) => element.id == id).toList();
  }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: const Text('An error occured.'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
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
  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'quantity': quantity,
        'title': title,
      };
}
