import 'package:garreta_picker_app/models/product.dart';
import 'package:garreta_picker_app/provider/product_provider.dart';

class CompletedOrders {
  CompletedOrders({
    required this.amount,
    required this.custContactNumber,
    required this.custId,
    required this.custName,
    required this.dateTime,
    required this.isDone,
    required this.products,
  });

  final double amount;
  final String custContactNumber;
  final String custId;
  final String custName;
  final DateTime dateTime;
  final bool isDone;
  final List<OrderedProduct> products;

  factory CompletedOrders.fromRTDB(Map<String, dynamic> json) =>
      CompletedOrders(
        custId: json['cust_id'],
        amount: json['amount'],
        custContactNumber: json['cust_contactNumber'],
        custName: json['cust_name'],
        dateTime: DateTime.parse(json['dateTime']),
        isDone: json['isDone'],
        products: (json['products'] as List<dynamic>)
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
      );
}
