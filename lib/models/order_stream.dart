import 'package:firebase_database/firebase_database.dart';
import 'package:garreta_picker_app/models/completed.dart';

class OrderStream {
  final _database = FirebaseDatabase.instance.reference();

  Stream<List<CompletedOrders>> getOrderStream() {
    final orderStream = _database.child('completedOrders').onValue;
    final streamToPublish = orderStream.map((event) {
      final orderMap = Map<String, dynamic>.from(event.snapshot.value);
      final orderList = orderMap.entries.map((element) {
        return CompletedOrders.fromRTDB(
            Map<String, dynamic>.from(element.value));
      }).toList();
      return orderList;
    });
    return streamToPublish;
  }
}
