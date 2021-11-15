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
  final List<Product> products;

  factory CompletedOrders.fromRTDB(Map<String, dynamic> json) =>
      CompletedOrders(
        amount: double.parse(json["amount"].toDouble()),
        custContactNumber: json["cust_contactNumber"],
        custId: json["cust_id"],
        custName: json["cust_name"],
        dateTime: DateTime.parse(json["dateTime"]),
        isDone: json["isDone"],
        products: List<Product>.from(
          json["products"]
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
}
