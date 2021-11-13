import 'package:garreta_picker_app/provider/product_provider.dart';
import 'package:intl/intl.dart';

class Order {
  final String? orderId;
  final double? amount;
  final String? name;
  final String? number;
  final String? customerId;
  final DateTime? dateTime;
  final bool? orderStatus;
  final List<OrderedProduct>? products;

  Order({
    this.orderId,
    this.amount,
    this.name,
    this.number,
    this.customerId,
    this.dateTime,
    this.orderStatus,
    this.products,
  });

  factory Order.fromRTDB(Map<String, dynamic> data) {
    return Order(
      customerId: data['cust_id'],
      amount: data['amount'],
      name: data['cust_name'],
      number: data['cust_contactNumber'],
      dateTime: DateFormat('MM-dd-yyyy').parse(data['dateTime']),
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
    );
  }
}
