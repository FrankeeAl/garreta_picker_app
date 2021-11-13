import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category {
  final String? title;
  final String? imgUrl;

  Category({required this.title, required this.imgUrl});

  factory Category.fromRTDB(Map<String, dynamic> data) {
    return Category(title: data['title'], imgUrl: data['imgUrl']);
  }
}

class Categories with ChangeNotifier {
  final _database = FirebaseDatabase.instance.reference();

  static const CATEGORY_PATH = 'categories/';
  final String clothes = 'Ocv2Bznc1cFfmKxcST2s.json';
  final String grocery = '8E3zsPEVZaPHjApkfhsA.json';
  final String electronics = 'KEfTifC7FBjHhK68w0Cq.json';

  final baseUrl =
      // 'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/categories/Ocv2Bznc1cFfmKxcST2s.json';
      'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/';
  final List<Category> _categories = [];

  List<Category>? get categories {
    return [..._categories];
  }

  Categories() {
    fetchClothesCategory();
    fetchGroceryCategory();
    fetchElectronicsCategory();
  }

  Future<void> getOnceCategoryClothes() async {
    try {
      await _database.child(CATEGORY_PATH).get().then(
        (snapshot) {
          final data = Map<String, dynamic>.from(snapshot.value);
          final category = Category?.fromRTDB(data);
          _categories.add(category);
        },
      );
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchClothesCategory() async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl + CATEGORY_PATH + clothes));
      // final List<Category> loadedData = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }
      final category = Category.fromRTDB(extractedData);

      _categories.add(category);
    } catch (e) {
      print(e.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> fetchGroceryCategory() async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl + CATEGORY_PATH + grocery));
      // final List<Category> loadedData = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }
      final category = Category.fromRTDB(extractedData);
      _categories.add(category);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchElectronicsCategory() async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl + CATEGORY_PATH + electronics));
      // final List<Category> loadedData = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }
      final category = Category.fromRTDB(extractedData);

      _categories.add(category);
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
}
