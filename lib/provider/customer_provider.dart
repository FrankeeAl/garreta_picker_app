import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import '../models/customer.dart';

class CustomerDetail with ChangeNotifier {
  List<Customer> _details = [];
  Customer? _customers;

  String? authToken;
  String? custId;

  CustomerDetail(
    this.authToken,
    this.custId,
    this._details,
  );

  List<Customer> get details {
    return [..._details];
  }

  Customer? get customers {
    return _customers;
  }

  String? getName;

  String? get merchantName {
    return getName;
  }

  Future<void> fetchDetailsById(String custId) async {
    print('$custId fetching ni sa details ni customer');
    final url =
        'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/customers.json?auth=$authToken&orderBy="cust_id"&equalTo="$custId"';

    try {
      final response = await http.get(Uri.parse(url));
      final List<Customer> loadedDetails = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      _customers = Customer.fromRTDB(extractedData);

      if (extractedData.isEmpty) {
        return;
      }

      extractedData.forEach((customerId, data) {
        loadedDetails.add(
          Customer(
            id: customerId,
            name: data['cust_name'],
            address: data['cust_address'],
            birthDate: DateTime.parse(data['cust_birthDate']),
            contact: data['cust_contactNumber'],
            email: data['cust_email'],
            gender: data['cust_gender'],
            reputation: data['cust_reputation'],
            status: data['cust_status'],
            registrationDate: DateTime.parse(data['cust_registrationDate']),
            totalOrders: data['cust_totalNumberOrders'],
            totalCancelled: data['cust_numberOfCancelledOrders'],
          ),
        );

        getName = data['cust_name'];
      });

      _details = loadedDetails;
      notifyListeners();
      print(json.decode(_details.toString()));
    } catch (e) {
      rethrow;
    }
  }
}
