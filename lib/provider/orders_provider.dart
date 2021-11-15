import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta_picker_app/models/http_exception.dart';

import '../models/orders.dart';

import 'package:http/http.dart' as http;
import 'product_provider.dart';

class OrderList with ChangeNotifier {
  List<Order> _orders = [];
  Order? _order;
  List<OrderedProduct> _orderedProduct = [];

  final String? authToken;
  final String? userId;

  OrderList(this.authToken, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  List<OrderedProduct> get orderedProducts {
    return [..._orderedProduct];
  }

  Order? get ordersList {
    return _order;
  }

  final baseUrl =
      'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/';

  Future<void> fetchOrders() async {
    final fetch = 'orders.json?auth=$authToken';

    try {
      final response = await http.get(Uri.parse(baseUrl + fetch));
      final List<Order> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }

      extractedData.forEach((orderId, data) {
        loadedOrders.add(
          Order(
            orderId: orderId,
            customerId: data['cust_id'],
            amount: data['amount'],
            name: data['cust_name'],
            number: data['cust_contactNumber'],
            dateTime: DateTime.parse(data['dateTime']),
            orderStatus: data['isDone'],
            products: (data['products'] as List<dynamic>)
                .map(
                  (item) => OrderedProduct(
                    id: item['id'],
                    title: item['title'],
                    description: item['description'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
        _orders = loadedOrders;
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updateOrder(String orderId) async {
    print('$orderId mao ni na orderId');
    const patch = 'orders.json';
    try {
      final url = baseUrl + patch;
      final existingOrderIndex =
          _orders.indexWhere((element) => element.orderId == orderId);
      var existingOrder = _orders[existingOrderIndex];

      await http.patch(Uri.parse(url), body: json.encode({'isDone': _orders}));

      _orders.add(existingOrder);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    final delete = '$userId.json';
    final url = baseUrl + delete;
    final existingOrderIndex =
        _orders.indexWhere((element) => element.orderId == id);
    var existingOrder = _orders[existingOrderIndex];

    _orders.removeAt(existingOrderIndex);

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException('Could not delete.');
    }
  }

  Order findById(String id) {
    return _orders.firstWhere((order) => order.orderId == id);
  }
}
