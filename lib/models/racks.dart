import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Rack {
  Rack({
    required this.category,
    required this.order,
    required this.title,
  });
  final String? title;
  final int? order;
  final String? category;

  factory Rack.fromJson(Map<String, dynamic> json) => Rack(
        category: json['category'],
        order: json['order'],
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'order': order,
        'category': category,
      };
}

class Racks with ChangeNotifier {
  static const racksPath = 'racks.json?';
  final baseUrl =
      'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/';

  List<Rack>? _racks = [];

  List<Rack>? get racks {
    return [..._racks!];
  }

  Future<void> getRacks() async {
    List<Rack> loadedData = [];
    try {
      final response = await http.get(Uri.parse(baseUrl + racksPath));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        print('wala may sulod...');
        return;
      }
      print('${extractedData.length} mao ni nakuha sa racks');
      extractedData.forEach((key, data) {
        loadedData.add(
          Rack(
            category: data['category'],
            order: data['order'],
            title: data['title'],
          ),
        );
      });
      _racks = loadedData;
    } catch (e) {
      print("Error: " + e.toString());
      rethrow;
    }
  }
}
