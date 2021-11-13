import 'package:intl/intl.dart';

class Customer {
  final String? id;
  final int? customerIntId;
  final String? name;
  final String? email;
  final String? contact;
  final String? address;
  final DateTime? birthDate;
  final DateTime? registrationDate;
  final int? status;
  final String? gender;
  final int? reputation;
  final int? totalOrders;
  final int? totalCancelled;

  Customer({
    this.id,
    this.customerIntId,
    this.name,
    this.email,
    this.contact,
    this.address,
    this.birthDate,
    this.registrationDate,
    this.status,
    this.gender,
    this.reputation,
    this.totalOrders,
    this.totalCancelled,
  });

  factory Customer.fromRTDB(Map<String, dynamic> json) {
    return Customer(
      name: json['cust_name'] ?? 'Frankee',
      email: json['cust_email'] ?? 'sample@email.com',
      contact: json['cust_contactNumber'] ?? '09564875845',
      address: json['cust_address'] ?? 'Sa puso at isip mo.',
      birthDate: DateFormat('dd-MM-yyyy').parse(json['cust_birthDate']),
      registrationDate:
          DateFormat('dd-MM-yyyy').parse(json['cust_registrationDate']),
      status: json['cust_status'],
      gender: json['cust_gender'],
      reputation: json['cust_reputation'],
      totalOrders: json['cust_numberOfOrders'],
      totalCancelled: json['cust_numberOfCancelledOrders'],
    );
  }
}
