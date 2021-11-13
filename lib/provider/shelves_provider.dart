import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:garreta_picker_app/models/shelf.dart';
import 'package:http/http.dart' as http;

class Shelves with ChangeNotifier {
  final String? code;
  final String? items;
  final int? order;

  Shelves({
    this.code,
    this.items,
    this.order,
  });

  final baseUrl =
      'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const bottomsPath = 'bottomsShelf.json?';
  static const topsPath = 'topsShelf.json?';
  static const hatsPath = 'hatsShelf.json?';

  // factory Shelves.fromJson(Map<String, dynamic> json) => Shelves(
  //       code: json["code"],
  //       items: json["items"],
  //       order: json["order"],
  //     );

  List<TopsShelves>? _topsShelves = [];
  List<BottomsShelves>? _bottomsShelves = [];
  List<HatsShelves>? _hatsShelves = [];
  List<Shelves>? _shelves = [];

  List<TopsShelves>? get topsShelves {
    return [..._topsShelves!];
  }

  List<BottomsShelves>? get bottomsShelves {
    return [..._bottomsShelves!];
  }

  List<HatsShelves>? get hatsShelves {
    return [..._hatsShelves!];
  }

  Future<void> getTopsShelf() async {
    List<TopsShelves> loadedData = [];

    print('Been here it get tops!');
    try {
      final response = await http.get(Uri.parse(baseUrl + topsPath));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        print('wala may sulod...');
        return;
      }

      // final data = Shelves.fromJson(extractedData);
      // _shelves!.add(data);

      print('${extractedData.length} mao ni nakuha sa tops');
      extractedData.forEach((key, data) {
        loadedData.add(
          TopsShelves(
            code: data["code"],
            items: data["items"],
            order: data["order"],
          ),
        );
      });
      _topsShelves = loadedData;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getBottomsShelf() async {
    List<BottomsShelves> loadedData = [];
    print('Been here it get tops!');
    try {
      final response = await http.get(Uri.parse(baseUrl + bottomsPath));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        print('wala may sulod...');
        return;
      }
      print('${extractedData.length} mao ni nakuha sa bottoms');
      extractedData.forEach((key, data) {
        loadedData.add(
          BottomsShelves(
            code: data['code'],
            items: data['items'],
            order: data['order'],
          ),
        );
      });
      // final loadedData = TopsShelves.fromRTDB(extractedData);
      // _topsShelves!.add(loadedData);
      _bottomsShelves = loadedData;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getHatsShelf() async {
    List<HatsShelves> loadedData = [];
    print('Been here it get tops!');
    try {
      final response = await http.get(Uri.parse(baseUrl + bottomsPath));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        print('wala may sulod...');
        return;
      }
      print('${extractedData.length} mao ni nakuha sa hats');
      extractedData.forEach((key, data) {
        loadedData.add(
          HatsShelves(
            code: data["code"],
            items: data["items"],
            order: data["order"],
          ),
        );
      });

      _hatsShelves = loadedData;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}
