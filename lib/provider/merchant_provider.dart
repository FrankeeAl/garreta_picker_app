import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/merchant.dart';

import 'package:http/http.dart' as http;

class Merchants with ChangeNotifier {
  final String? authToken;
  final String? userId;

  Merchants(
    this.authToken,
    this.userId,
  );
  List<Merchant?> _merchant = [];

  List<Merchant?> get merchant {
    return [..._merchant];
  }

  String? getName;

  String? get merchantName {
    return getName;
  }

  Future<void> fetchMerchant() async {
    print('Fetching data...$userId');
    final url =
        'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/merchants.json?auth=$authToken&orderBy="token"&equalTo="$userId"';

    try {
      final response = await http.get(Uri.parse(url));
      final List<Merchant> loadedMerchants = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        print('true extractedData is empty.');
        return;
      }
      print('${extractedData.length} sa merchant ni');

      extractedData.forEach((merchantId, data) => {
            loadedMerchants.add(
              Merchant(
                id: merchantId,
                title: data['title'],
                contactPerson: data['contactPerson'],
                contactNumber: data['contactNumber'],
                smsNumber: data['smsNumber'],
                emailAddress: data['emailAddress'],
                businessAddress: data['businessAddress'],
                kmAllocated: data['kmAllocated'],
                businessHours: data['businessHours'],
                rating: int.parse(data['rating']),
                status: int.parse(data['status']),
                token: data['token'],
                dateRegistered: DateTime.parse(data['dateRegistered']),
              ),
            ),
            getName = data['title'],
          });
      _merchant = loadedMerchants;
      print('Exit fetching merchant data...Authentication');
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  String? findByToken(String? token) {
    final merchantDetails =
        _merchant.firstWhereOrNull((merchant) => merchant!.token == token);
    final name = merchantDetails?.title;
    return name;
  }
}



//   Future<void> addMerchant(Merchant merchant) async {
//     final url =
//         'https://merch-picker-app-default-rtdb.asia-southeast1.firebasedatabase.app/merchants.json?auth=$authToken';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: json.encode({
//           'name': merchant.name,
//           'contactPerson': merchant.contactPerson,
//           'contactNumber': merchant.contactNumber,
//           'smsNumber': merchant.smsNumber,
//           'emailAddress': merchant.emailAddress,
//           'businessAddress': merchant.businessAddress,
//           'kmAllocated': merchant.kmAllocated,
//           'longitude': merchant.longitude,
//           'latitude': merchant.latitude,
//           'rating': merchant.rating,
//           'status': merchant.status,
//           'dateRegistered': merchant.dateRegistered,
//           'businessHours': merchant.businessHours,
//           'token': merchant.token,
//         }),
//       );

//       final newMerchant = Merchant(
//         id: json.decode(response.body)['name'],
//         name: merchant.name,
//         contactPerson: merchant.contactPerson,
//         contactNumber: merchant.contactNumber,
//         smsNumber: merchant.smsNumber,
//         emailAddress: merchant.emailAddress,
//         businessAddress: merchant.businessAddress,
//         businessHours: merchant.businessHours,
//         kmAllocated: merchant.kmAllocated,
//         longitude: merchant.longitude,
//         latitude: merchant.latitude,
//         rating: merchant.rating,
//         status: merchant.status,
//         dateRegistered: merchant.dateRegistered,
//         token: merchant.token,
//       );

//       _merchants.add(newMerchant);
//       // _merchants.insert(0, newMerchant);
//       notifyListeners();
//     } catch (e) {
//       rethrow;
//     }
//   }

